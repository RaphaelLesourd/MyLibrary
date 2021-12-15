//
//  FeedBackManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/12/2021.
//

import MessageUI
import UIKit

protocol FeedBackProtocol {
    func presentMail()
}

class FeedbackManager: NSObject {
    
    // MARK: - Propperties
    private var presentationController: UIViewController?
    private let recipientEmail = "birkyboy@icloud.com"
    private let appVersion = "\(UIApplication.appName) - \(Text.Misc.appVersion) \(UIApplication.version)"
    
    // MARK: - Initializer
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
}
// MARK: - Extension FeedBaclProtocol
extension FeedbackManager: FeedBackProtocol {
    func presentMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setMessageBody("<p>\(appVersion)</p>", isHTML: true)

            presentationController?.present(mail, animated: true)
        } else {
            AlertManager.presentAlertBanner(as: .error, subtitle: Text.Banner.unableToOpenMailAppTitle)
        }
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
        case .cancelled:
            break
        case .failed:
            break
        case .saved:
            break
        case .sent:
            AlertManager.presentAlertBanner(as: .success, subtitle: Text.Banner.feedbackSentTitle)
        @unknown default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
