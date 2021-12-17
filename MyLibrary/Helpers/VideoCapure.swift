//
//  VideoCapure.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/12/2021.
//

import AVFoundation
import Vision
import UIKit

protocol VideoCaptureDelegate: AnyObject {
    var fetchedBarcode: String? { get set }
    func showPermissionsAlert()
    func presentNoCameraAlert()
}

/// Class allowing to scan barcode. It returns a string value used as ISBN for api search.
/// Process assimilated and adapated from this article
/// https://www.raywenderlich.com/12663654-vision-framework-tutorial-for-ios-scanning-barcodes
class VideoCapture: NSObject {
 
    var captureSession = AVCaptureSession()
    private weak var presentationController: UIViewController?
    private weak var delegate: VideoCaptureDelegate?
    
    /// Set up a VNDetectBarcodesRequest that will detect barcodes when called.
    /// - When the method found a barcode, it’ll pass the barcode on to processClassification(_:)..
    private lazy var detectBarcodeRequest = VNDetectBarcodesRequest { [weak self] request, error in
        if let error = error {
            AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
            return
        }
        self?.processClassification(request)
    }
    
    init(presentationController: UIViewController, delegate: VideoCaptureDelegate) {
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    // MARK: - Camera
    /// Prompt the user for permission to use the camera if not already authorized.
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCameraLiveView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                if !granted {
                    self.delegate?.showPermissionsAlert()
                }
            }
        case .denied, .restricted:
            delegate?.showPermissionsAlert()
        default:
            return
        }
    }
    /// Setup camera session.
    /// - captureSession is an instance of AVCaptureSession.
    /// - With an AVCaptureSession, you can manage capture activity and coordinate how data flows from input devices to capture outputs.
    func setupCameraLiveView() {
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
                  delegate?.presentNoCameraAlert()
                  return nil
              }
        return videoDeviceInput
    }
    /// Set the output of your capture session to an instance of AVCaptureVideoDataOutput.
    /// - AVCaptureVideoDataOutput is a capture output that records video and provides access to video frames for processing.
    private func addCaptureOutput() {
        DispatchQueue.global(qos: .userInitiated).async {
            let captureOutput = AVCaptureVideoDataOutput()
            // Set video sample rate
            captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
            self.captureSession.addOutput(captureOutput)
            self.configurePreviewLayer()
            self.captureSession.startRunning()
        }
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
                presentationController?.view.layer.sublayers?.removeSubrange(1...)
                for barcode in barcodes {
                    guard let potentialQRCode = barcode as? VNBarcodeObservation,
                          potentialQRCode.symbology != .QR,
                          potentialQRCode.confidence > 0.9
                    else { return }
                    delegate?.fetchedBarcode = potentialQRCode.payloadStringValue
                    presentationController?.dismiss(animated: true)
                }
            }
        }
    }
    // MARK: - Overlay
    private func configurePreviewLayer() {
        DispatchQueue.main.async {
            let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            cameraPreviewLayer.videoGravity = .resizeAspectFill
            cameraPreviewLayer.connection?.videoOrientation = .portrait
            cameraPreviewLayer.frame = self.presentationController?.view.bounds ?? CGRect(x: 0, y: 0, width: 200, height: 200)
            self.presentationController?.view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        }
    }
}
// MARK: - AVCaptureDelegation
extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    /// Get an image out of sample buffer, like a page out of a flip book.
    /// - Make a new VNImageRequestHandler using that image.
    /// - Perform the detectBarcodeRequest using the handler.
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
        do {
            try imageRequestHandler.perform([detectBarcodeRequest])
        } catch {
            AlertManager.presentAlertBanner(as: .error, subtitle: error.localizedDescription)
        }
    }
}
