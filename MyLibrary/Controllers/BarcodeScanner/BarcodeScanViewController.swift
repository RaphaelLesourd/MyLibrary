//
//  BarcodeScannerViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
import AVFoundation
import CloudKit

class BarcodeScanViewController: UIViewController {

    // MARK: - Properties
    let mainView = BarcodeControllerView()
    weak var barcodeDelegate: BarcodeScannerDelegate?
    var fetchedBarcode: String?
    var flashLightIsOn = false {
        didSet {
            toggleFlashlight(onState: flashLightIsOn)
            mainView.toggleButton(onState: flashLightIsOn)
        }
    }
    private var barcodeCapture: BarcodeReader?
    
    // MARK: - Initializer
    init(barcodeDelegate: BarcodeScannerDelegate?) {
        self.barcodeDelegate = barcodeDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecyle
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
        barcodeCapture = BarcodeReader(presentationController: self,
                                       delegate: self,
                                       permissions: PermissionManager())
        mainView.flashLightButton.addAction(UIAction(handler: { [weak self] _ in
            self?.flashLightIsOn.toggle()
        }), for: .touchUpInside)
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
    
    // MARK: - Flashlight
    private func toggleFlashlight(onState: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = onState ? .on : .off
            if onState {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            }
            device.unlockForConfiguration()
        } catch {
            AlertManager.presentAlertBanner(as: .customMessage(Text.Banner.noFlashLightTitle),
                                            subtitle: Text.Banner.flashLightErrorMessage)
        }
    }
    
}

// MARK: - Extension barcode capture delegate
extension BarcodeScanViewController: BarcodeReaderDelegate {
 
    func presentError(with error: BarcodeReaderError) {
        AlertManager.presentAlertBanner(as: .customMessage(error.title),
                                        subtitle: error.description)
        dismissViewController()
    }
    
    func provideBarcode(with data: String?) {
        guard let data = data else { return }
        barcodeDelegate?.processBarcode(with: data)
        dismissViewController()
    }
}
