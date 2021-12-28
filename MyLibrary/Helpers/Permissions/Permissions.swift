//
//  Permissions.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol Permissions {
    func requestCameraPermissions(completion: @escaping (Bool) -> Void)
    func requestPhotoPermission(completion: @escaping (Bool) -> Void)
}
