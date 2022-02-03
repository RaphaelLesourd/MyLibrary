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
    
    /// Handles received push notification content.
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let content = bestAttemptContent else {
            return self.displayOriginalContent()
        }
        let userInfo: [AnyHashable: Any] = request.content.userInfo
       // Check if an image URL exists
        guard let attachmentURL = userInfo["imageURL"] as? String,
              let url = URL(string: attachmentURL),
              let imageData = try? Data(contentsOf: url) else {
                  return self.displayOriginalContent()
              }
        // Download the image and save to disk
        guard let attachment = self.save("image.png", data: imageData, options: nil) else {
            return self.displayOriginalContent()
        }
        // Attach the image file URL to the notification
        content.attachments = [attachment]
        // Send back the modified notification
        contentHandler(content)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        displayOriginalContent()
    }

    // MARK: - Private functions
    private func displayOriginalContent() {
        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    /// Save the pushnotification image to disk.
    private func save(_ identifier: String, data: Data, options: [AnyHashable: Any]?) -> UNNotificationAttachment? {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        let directory = url.appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString, isDirectory: true)
        do {
            try? FileManager.default.createDirectory(at: directory,  withIntermediateDirectories: true, attributes: nil)
            let fileURL = directory.appendingPathComponent(identifier)
            try? data.write(to: fileURL, options: [])
            return try? UNNotificationAttachment.init(identifier: identifier, url: fileURL, options: options)
        }
    }
}
