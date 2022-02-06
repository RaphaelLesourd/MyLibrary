//
//  FeedbackManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import MessageUI

class FeedbackManager: NSObject {
    
    private let appVersion = "\(UIApplication.appName) - \(Text.Misc.appVersion) \(UIApplication.version)"
  
}
// MARK: - MFMailCompse Delegate
extension FeedbackManager: MFMailComposeViewControllerDelegate {
   
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result {
        case .cancelled, .saved:
           break
        case .failed:
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.unsentEmail)
        case .sent:
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.sentEmail)
        @unknown default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
// MARK: - FeedBack Sender
extension FeedbackManager: FeedbackManagerProtocol {

    func presentMail(on controller: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.unableToOpenMailAppTitle)
            return
        }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([Keys.feedbackEmail])
        mail.setMessageBody("<p>\(appVersion)</p>", isHTML: true)
        controller.present(mail, animated: true)
    }
}
