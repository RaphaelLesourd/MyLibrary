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
    
    /// Set up a VNDetectBarcodesRequest that will detect barcodes when called.
    /// - When the method found a barcode, it’ll pass the barcode on to processClassification(_:)..
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
    /// Prompt the user for permission to use the camera if not already authorized.
    private func checkPermissions() {
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
    
    /// Setup camera session.
    /// - captureSession is an instance of AVCaptureSession.
    /// - With an AVCaptureSession, you can manage capture activity and coordinate how data flows from input devices to capture outputs.
    private func setupCameraLiveView() {
        captureSession.sessionPreset = .hd1280x720
        guard let videoDeviceInput = addVideoInput() else { return }
        captureSession.addInput(videoDeviceInput)
        addCaptureOutput()
    }
    
    /// Defines a Camera for Input
    /// - Uses default wide angle camera, located on the rear of the iPhone.
    /// - Making sure your app can use the camera as an input device for the capture session.
    /// - If there’s a problem with the camera, show the user an error message.
    /// - Returns: Rear wide angle camera as the input device for the capture session
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
    
    /// Set the output of your capture session to an instance of AVCaptureVideoDataOutput.
    /// - AVCaptureVideoDataOutput is a capture output that records video and provides access to video frames for processing.
    private func addCaptureOutput() {
        let captureOutput = AVCaptureVideoDataOutput()
        // Set video sample rate
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        captureSession.addOutput(captureOutput)
        configurePreviewLayer()
        captureSession.startRunning()
    }
    
    // MARK: - Vision
    /// Analyze the result of the handled request.
    /// - Get a list of potential barcodes from the request.
    /// - Loop through the potential barcodes to analyze each one individually.
    /// - A positive result is passed back to the previous view controller
    /// - Parameter request: VNDetectBarcodesRequest from detectBarcodeRequest
    func processClassification(_ request: VNRequest) {
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
    
    /// Get an image out of sample buffer, like a page out of a flip book.
    /// - Make a new VNImageRequestHandler using that image.
    /// - Perform the detectBarcodeRequest using the handler.
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
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
