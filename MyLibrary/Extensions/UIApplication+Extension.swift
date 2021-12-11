//
//  UIApplication+Extension.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/12/2021.
//

import UIKit

extension UIApplication {
    static var appName: String {
        if let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return name
        }
        return ""
    }
    static var release: String {
        if let release =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return release
        }
        return "x.x"
    }
    static var build: String {
        if let build =  Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return build
        }
        return "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
