//
//  PushNotifications.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import UserNotifications

protocol PushNotifications {
    func registerNotifications()
    func resetNotificationBadgeCount()
    func didReceive(_ notification: UNNotification)
}
