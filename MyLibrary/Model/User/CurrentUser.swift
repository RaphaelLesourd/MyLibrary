//
//  CurrentUser.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/10/2021.
//

import Foundation

class CurrentUser {
    static let shared = CurrentUser()
    var user: UserModel?
}
