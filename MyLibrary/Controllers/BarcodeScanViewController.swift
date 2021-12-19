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

class BarcodeScanViewController: UIViewController {
    
    // MARK: - Properties
    var fetchedBarcode: String?
    let mainView = BarcodeControllerView()
    weak var barcodeDelegate: BarcodeProtocol?
    
    private var barcodeCapture: BarcodeCapture?
    
    // MARK: - Lifecyle
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodeCapture = BarcodeCapture(presentationController: self, delegate: self)
        barcodeCapture?.checkPermissions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        barcodeCapture?.captureSession.stopRunning()
        barcodeResultHandler()
        mainView.animationView.stop()
    }
    
    // MARK: - Private functions
    /// Check if there is a barcode after scanning. If not NIl then it is passed back to the previous controller.
    private func barcodeResultHandler() {
        guard let fetchedBarcode = fetchedBarcode else { return }
        barcodeDelegate?.processBarcode(with: fetchedBarcode)
    }
}
// MARK: - Extension barcode capture delegate
extension BarcodeScanViewController: BarcodeCaptureDelegate {
    
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
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}
// MARK: - PanModal Extension

/// Configure the pan modal VviewController
extension BarcodeScanViewController: PanModalPresentable {
    
    var isHapticFeedbackEnabled: Bool {
        return true
    }
    var cornerRadius: CGFloat {
        return 20
    }
    var panScrollable: UIScrollView? {
        return nil
    }
}
