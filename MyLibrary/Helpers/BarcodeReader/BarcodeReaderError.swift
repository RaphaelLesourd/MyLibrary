//
//  BarcodeReaderError.swift
//  MyLibrary
//
//  Created by Birkyboy on 21/12/2021.
//

enum BarcodeReaderError: Error {
    case restrictedAccess
    case noCamera
    case noFlashlight
    case defaultError(Error)

    var title: String {
        switch self {
        case .restrictedAccess:
            return Text.Banner.cameraPermissionsTitle
        case .noCamera:
            return Text.Alert.cameraUnavailableTitle
        case .defaultError(_):
            return Text.Banner.errorTitle
        case .noFlashlight:
            return Text.Banner.noFlashLightTitle
        }
    }
    var description: String {
        switch self {
        case .restrictedAccess:
            return Text.Banner.cameraPermissionsMessage
        case .noCamera:
            return Text.Alert.cameraUnavailableMessage
        case .defaultError(let error):
            return error.localizedDescription
        case .noFlashlight:
            return Text.Misc.unavailable
        }
    }
}
