//
//  PhotoLibraryAccessManager.swift
//  P4_Instagrid
//
//  Created by Birkyboy on 19/04/2021.
//

import Foundation
import Photos
import UIKit

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func presentAlertBanner(as type: AlertBannerType, subtitle: String)
}

// Source code and process assimilated from this article
// https://theswiftdev.com/picking-images-with-uiimagepickercontroller-in-swift-5/
open class ImagePicker: NSObject {

    // MARK: - Properties
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    // MARK: - Initializer
    /// Initialize the ImagePicker  and set properties.
    /// - Parameters:
    ///   - presentationController: ViewController calling the ImagePicker
    ///   - delegate: ImagePickerDelegate
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
        if self.pickerController.sourceType == .camera {
            self.pickerController.showsCameraControls = true
        }
    }
    
    // MARK: - Picker
    ///  Image picker presneting the device photos.
    /// - Parameters:
    ///   - image: Image elected by the user
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
    
    // MARK: - Alert Controller
    /// Defines action for selected source type to be used in an UIAlertController
    ///  - A user can choose to take a photo, select from camera rool or photo library.
    /// - Parameters:
    ///   - type: Source type (camera, camera roll, photo library
    ///   - title: Name of the source type to be presented to the user.
    /// - Returns: Alert action
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    /// Present a menu to choose a source type.
    /// - Three sources are avaiable, camera, camera roll, photo library.
    /// - Parameter sourceView: source calling the method
    public func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        // verifies permission before presenting the menu
        requestAccessPermission { [weak self] granted in
            if granted {
                self?.presentationController?.present(alertController, animated: true)
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.presentAlertBanner(as: .customMessage("Pélicule photo"), subtitle: "Acces non autorisé")
                }
            }
        }
    }
    
    // MARK: - Authorization request
    /// Request user permission to access the photo library or camera.
    /// - If authotization station is undetermined, the request authorization is done again.
    /// - Parameter completion: return true or false if access is granted or not.
    func requestAccessPermission(completion: @escaping (Bool) -> Void) {
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
// MARK: - UIImagepickerController Delegate
extension ImagePicker: UIImagePickerControllerDelegate {
    
    /// Hande user cancel action, return no image.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    /// Handles the image when the user has selected one.
    /// - Uses the original , un edited image.
    /// - Unwrap the image optional, if an image is present it is passed to the call controller via the ImagePickerDelegate protocol.
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {}
