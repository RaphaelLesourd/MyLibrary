//
//  FirebaseCloudMessagingService.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/01/2022.
//

import Alamofire

class FirebaseCloudMessagingService {
 
    private let session: Session

    init(session: Session) {
        self.session = session
    }
}

extension FirebaseCloudMessagingService: PostNotificationService {

    func sendPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void) {
        let parameters = AlamofireRouter.pushMessage(with: message)
        session
            .request(parameters)
            .validate(statusCode: 200..<504)
            .response { response in
                switch response.result {
                case .success(_):
                    // Error path, present an error message corresponding to the error code
                    guard let httpErrorCode = response.response?.statusCode else { return }
                    guard httpErrorCode == 200 || httpErrorCode == 204 else {
                        return completion(.httpError(httpErrorCode))
                    }
                    // Happy path, return no error posted notifications silently
                    completion(nil)
                case .failure(let error):
                    completion(.afError(error))
                }
            }
    }
}
