//
//  FeedbackManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UIKit
import MessageUI

class FeedbackManager: NSObject {
    
    // MARK: - Propperties
    private var presentationController: UIViewController?
    private let appVersion = "\(UIApplication.appName) - \(Text.Misc.appVersion) \(UIApplication.version)"
    
    // MARK: - Initializer
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
}
// MARK: - Extension MFMailCompseDelegate
extension FeedbackManager: MFMailComposeViewControllerDelegate {
   
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
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
// MARK: - Extension FeedBackSender
extension FeedbackManager: FeedbackManagerProtocol {
    func presentMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Keys.feedbackEmail])
            mail.setMessageBody("<p>\(appVersion)</p>", isHTML: true)

            presentationController?.present(mail, animated: true)
        } else {
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.unableToOpenMailAppTitle)
        }
    }
}
