//
//  BarcodeScannerViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
import PanModal

/// Protocol to pass barcode string value back to the requesting controller.
protocol BarcodeProtocol: AnyObject {
    func processBarcode(with code: String)
}

class BarcodeScanViewController: UIViewController, VideoCaptureDelegate {
    
    // MARK: - Properties
    var fetchedBarcode: String?
    weak var barcodeDelegate: BarcodeProtocol?
    private var videoCapture: VideoCapture?
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        videoCapture = VideoCapture(presentationController: self, delegate: self)
        videoCapture?.checkPermissions()
        videoCapture?.setupCameraLiveView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCapture?.captureSession.stopRunning()
        barcodeResultHandler()
    }
    // MARK: - Handler
    /// Check if there is a barcode after scanning. If not NIl then it is passed back to the previous controller.
    private func barcodeResultHandler() {
        guard let fetchedBarcode = fetchedBarcode else { return }
        barcodeDelegate?.processBarcode(with: fetchedBarcode)
    }
    
    func presentNoCameraAlert() {
        AlertManager.presentAlert(withTitle: Text.Alert.cameraUnavailableTitle,
                                  message: Text.Alert.cameraUnavailableMessage,
                                  on: self) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    /// Display alert tot the user when the use of camera is not granted for any reasons.
    func showPermissionsAlert() {
        AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.cameraPermissionsTitle),
                                        subtitle: Text.Banner.cameraPermissionsMessage)
    }
}
// MARK: - PanModal Extension
extension BarcodeScanViewController: PanModalPresentable {
    
    var shortFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(view.frame.height * 0.20)
    }
    var cornerRadius: CGFloat {
        return 20
    }
    var panScrollable: UIScrollView? {
        return nil
    }
}
