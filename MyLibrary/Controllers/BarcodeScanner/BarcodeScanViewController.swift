//
//  BarcodeScannerViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
import AVFoundation

class BarcodeScanViewController: UIViewController {

    let mainView = BarcodeControllerView()
    weak var barcodeDelegate: BarcodeScannerDelegate?
    var barcode: String?
    var flashLightIsOn = false {
        didSet {
            toggleFlashlight(on: flashLightIsOn)
            mainView.toggleButton(onState: flashLightIsOn)
        }
    }
    private var barcodeCapture: BarcodeReader?

    init(barcodeDelegate: BarcodeScannerDelegate?) {
        self.barcodeDelegate = barcodeDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        barcodeCapture = BarcodeReader(presentationController: self,
                                       delegate: self,
                                       permissions: PermissionManager())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
        barcodeCapture?.stopCameraLiveView()
        mainView.animationView.stop()
        flashLightIsOn = false
    }
    
    private func dismissViewController() {
        if #available(iOS 15.0, *) {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func toggleFlashlight(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            if on {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            device.unlockForConfiguration()
        } catch {
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.noFlashLightTitle),
                                            subtitle: Text.Banner.flashLightErrorMessage)
        }
    }
    
}

// MARK: - Barcode capture delegate
extension BarcodeScanViewController: BarcodeReaderDelegate {
 
    func presentError(with error: BarcodeReaderError) {
        AlertManager.presentAlertBanner(as: .customMessage(error.title),
                                        subtitle: error.description)
        dismissViewController()
    }

    /// Receive  the baraode from the BarCodeReader and pass it on.
    func provideBarcode(with data: String?) {
        guard let data = data else { return }
        barcodeDelegate?.processBarcode(with: data)
        dismissViewController()
    }
}
// MARK: - Barcodescanner view delegate
extension BarcodeScanViewController: BarcodeControllerViewDelegate {
    func toggleFlashlight() {
        flashLightIsOn.toggle()
    }
}
