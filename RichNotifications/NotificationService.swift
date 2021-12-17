//
//  NotificationService.swift
//  RichNotifications
//
//  Created by Birkyboy on 17/12/2021.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        DispatchQueue.main.async {
            guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
                return self.displayOriginalContent()
            }
            let userInfo: [AnyHashable: Any] = request.content.userInfo
            guard let attachmentURL = userInfo["imageURL"] as? String,
                  let url = URL(string: attachmentURL),
                  let imageData = try? Data(contentsOf: url) else {
                      return self.displayOriginalContent()
                  }
            guard let attachment = self.save("image.png", data: imageData, options: nil) else {
                return self.displayOriginalContent()
            }
            content.attachments = [attachment]
            contentHandler(content)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        displayOriginalContent()
    }
    
    private func displayOriginalContent() {
        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func save(_ identifier: String, data: Data, options: [AnyHashable: Any]?) -> UNNotificationAttachment? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        let directory = url.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory,  withIntermediateDirectories: true, attributes: nil)
            let fileURL = directory.appendingPathComponent(identifier)
            try data.write(to: fileURL, options: [])
            return try UNNotificationAttachment.init(identifier: identifier, url: fileURL, options: options)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
