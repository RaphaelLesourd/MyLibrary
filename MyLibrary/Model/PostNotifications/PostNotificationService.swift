//
//  PostNotificationService.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/01/2022.
//

protocol PostNotificationService {
    func sendPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void)
}
