//
//  BarcodeScannerViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
import AVFoundation

class BarcodeScanViewController: UIViewController {

    // MARK: - Properties
    let mainView = BarcodeControllerView()
    weak var barcodeDelegate: BarcodeScannerDelegate?
    var fetchedBarcode: String?
    var flashLightIsOn = false {
        didSet {
            toggleTorch(onState: flashLightIsOn)
            mainView.toggleButton(onState: flashLightIsOn)
        }
    }
    private var barcodeCapture: BarcodeReader?
    
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
        barcodeCapture = BarcodeReader(presentationController: self, delegate: self)
        mainView.flashLightButton.addTarget(self, action: #selector(toggleFlashLight), for: .touchUpInside)
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
    
    @objc private func toggleFlashLight() {
        flashLightIsOn.toggle()
    }
    
    private func toggleTorch(onState: Bool) {
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
            print("Torch could not be used")
        }
    }
    
}

// MARK: - Extension barcode capture delegate
extension BarcodeScanViewController: BarcodeProvider {
 
    func presentError(with error: BarcodeReaderError) {
        AlertManager.presentAlertBanner(as: .customMessage(error.title), subtitle: error.description)
        dismissViewController()
    }
    
    func provideBarcode(with data: String?) {
        guard let data = data else { return }
        barcodeDelegate?.processBarcode(with: data)
        dismissViewController()
    }
}