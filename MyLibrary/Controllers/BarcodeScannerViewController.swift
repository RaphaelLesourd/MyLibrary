//
//  BarcodeScannerViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit
import Vision
import AVFoundation
import PanModal

/// Protocol to pass barcode string value back to the requesting controller.
protocol BarcodeProtocol: AnyObject {
    func processBarcode(with code: String)
}

/// Class allowing to scan barcode. It returns a string value used as ISBN for api search.
/// Learn this process at: https://www.raywenderlich.com/12663654-vision-framework-tutorial-for-ios-scanning-barcodes
class BarcodeScannerViewController: UIViewController {
    
    // MARK: - Properties
    private var captureSession = AVCaptureSession()
    private var fetchedBarcode: String?
    weak var barcodeDelegate: BarcodeProtocol?
    
    /// Create VNDetectBarcodesRequest variable.
    private lazy var detectBarcodeRequest = VNDetectBarcodesRequest { request, error in
        guard error == nil else {
            self.presentAlert(withTitle: "Barcode error", message: error?.localizedDescription ?? "error", actionHandler: nil)
            return
        }
        self.processClassification(request)
    }
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        checkPermissions()
        setupCameraLiveView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
        barcodeResultHandler()
    }
    
    // MARK: - Camera
    private func checkPermissions() {
        // TODO: Checking permissions
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                if !granted {
                    self.showPermissionsAlert()
                }
            }
        case .denied, .restricted:
            showPermissionsAlert()
        default:
            return
        }
    }
    
    private func setupCameraLiveView() {
        // TODO: Setup captureSession
        captureSession.sessionPreset = .hd1280x720
        guard let videoDeviceInput = addVideoInput() else { return }
        captureSession.addInput(videoDeviceInput)
        addCaptureOutput()
    }
    
    private func addVideoInput() -> AVCaptureDeviceInput? {
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let device = videoDevice,
              let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(videoDeviceInput) else {
                presentAlert(withTitle: "Cannot Find Camera",
                             message: "There seems to be a problem with the camera on your device.",
                             actionHandler: { [weak self] _ in
                    self?.dismiss(animated: true)
                })
                return nil
            }
        return videoDeviceInput
    }
    
    private func addCaptureOutput() {
        let captureOutput = AVCaptureVideoDataOutput()
        // TODO: Set video sample rate
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        captureSession.addOutput(captureOutput)
        
        configurePreviewLayer()
        captureSession.startRunning()
    }
    
    // MARK: - Vision
    func processClassification(_ request: VNRequest) {
        // TODO: Main logic
        guard let barcodes = request.results else { return }
        DispatchQueue.main.async { [self] in
            if captureSession.isRunning {
                view.layer.sublayers?.removeSubrange(1...)
                
                for barcode in barcodes {
                    guard let potentialQRCode = barcode as? VNBarcodeObservation,
                          potentialQRCode.symbology != .QR,
                          potentialQRCode.confidence > 0.9
                    else { return }
                    fetchedBarcode = potentialQRCode.payloadStringValue
                    dismiss(animated: true)
                }
            }
        }
    }
    // MARK: - Handler
    /// Check if there is a barcode after scanning. If not NIl then it is passed back to the previous controller.
    private func barcodeResultHandler() {
        guard let fetchedBarcode = fetchedBarcode else { return }
        barcodeDelegate?.processBarcode(with: fetchedBarcode)
    }
    
    // MARK: - Helper methods
    private func configurePreviewLayer() {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    /// Display alert tot the user when the use of camera is nt granted for any reasons.
    private func showPermissionsAlert() {
      presentAlert(withTitle: "Camera Permissions",
                   message: "Please open Settings and grant permission for this app to use your camera.",
                   actionHandler: nil)
    }
}
// MARK: - AVCaptureDelegation
extension BarcodeScannerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    // TODO: Live Vision
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
    do {
      try imageRequestHandler.perform([detectBarcodeRequest])
    } catch {
        presentAlertBanner(as: .error, subtitle: error.localizedDescription)
    }
  }
}

// MARK: - PanModal Extension
extension BarcodeScannerViewController: PanModalPresentable {
   
    var shortFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(view.frame.height * 0.50)
    }
   
    var cornerRadius: CGFloat {
        return 20
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
}
