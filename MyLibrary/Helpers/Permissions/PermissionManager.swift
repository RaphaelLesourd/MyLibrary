//
//  CamraPermission.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

import AVFoundation
import Photos

class PermissionManager {
    /// Prompt the user for permission to use the camera if not already authorized.
    func requestCameraPermissions(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationstatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationstatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            completion(false)
        default:
            completion(false)
        }
    }
    
    // MARK: - Authorization request
    /// Request user permission to access the photo library or camera.
    /// - If authotization station is undetermined, the request authorization is done again.
    /// - Parameter completion: return true or false if access is granted or not.
    func requestPhotoPermission(completion: @escaping (Bool) -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    completion(true)
                }
            })
        case .restricted, .denied:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
}

extension PermissionManager: Permissions {}