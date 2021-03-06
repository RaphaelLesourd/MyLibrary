//
//  PhotoLibraryAccessManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 15/10/2021.
//

import Photos
import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

// Source code and process assimilated and adapated from this article
// https://theswiftdev.com/picking-images-with-uiimagepickercontroller-in-swift-5/

class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var permissions: Permissions

    /// Initialize the ImagePicker  and set properties.
    /// - Parameters:
    ///   - presentationController: ViewController calling the ImagePicker
    ///   - delegate: ImagePickerDelegate
    init(presentationController: UIViewController,
         delegate: ImagePickerDelegate,
         permissions: Permissions) {
        self.pickerController = UIImagePickerController()
        self.presentationController = presentationController
        self.delegate = delegate
        self.permissions = permissions
        super.init()
        setupImagePicker()
    }
    
    /// Present a menu to choose a source type.
    /// - Three sources are avaiable, camera, camera roll, photo library.
    /// - Parameter sourceView: source calling the method
    func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let cameraAction = self.action(for: .camera, title: Text.ButtonTitle.camera) {
            alertController.addAction(cameraAction)
        }
        if let photoAction = self.action(for: .savedPhotosAlbum, title: Text.ButtonTitle.cameraRoll) {
            alertController.addAction(photoAction)
        }
        alertController.addAction(UIAlertAction(title: Text.ButtonTitle.cancel, style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        presentationController?.present(alertController, animated: true)
    }

    // MARK: - Private functions
    private func setupImagePicker() {
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
        if self.pickerController.sourceType == .camera {
            self.pickerController.showsCameraControls = true
        }
    }
    
    ///  Image picker presneting the device photos.
    /// - Parameters:
    ///   - image: Image elected by the user
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }

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
            switch type {
            case .photoLibrary, .savedPhotosAlbum:
                permissions.requestPhotoPermission { [weak self] granted in
                    self?.presentPhotoPicker(isGranted: granted,
                                             errorTitle: Text.ButtonTitle.photoLibrary,
                                             errorMessage: Text.Banner.accessNotAuthorizedMessage)
                }
            case .camera:
                permissions.requestCameraPermissions { [weak self] granted in
                    self?.presentPhotoPicker(isGranted: granted,
                                             errorTitle: Text.Banner.cameraPermissionsTitle,
                                             errorMessage: Text.Banner.cameraPermissionsMessage)
                }
            @unknown default:
                return
            }
        }
    }
    
    private func presentPhotoPicker(isGranted: Bool, errorTitle: String, errorMessage: String) {
        guard isGranted == true else {
            return AlertManager.presentAlertBanner(as: .customMessage(errorTitle), subtitle: errorMessage)
        }
        DispatchQueue.main.async {
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
}
// MARK: - UIImagepickerController Delegate
extension ImagePicker: UIImagePickerControllerDelegate {
    
    /// Hande user cancel action, return no image.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController.dismiss(animated: true, completion: nil)
    }
    /// Handles the image when the user has selected one.
    /// - Uses the original , un edited image.
    /// - Unwrap the image optional, if an image is present it is passed to the call controller via the ImagePickerDelegate protocol.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: Images.emptyStateBookImage)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {}
