//
//  BarcodeReader.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/12/2021.
//

import AVFoundation
import Vision
import UIKit

/// Class allowing to scan barcode. It returns a string value used as ISBN for api search.
class BarcodeReader: NSObject {
    
    private let captureSession = AVCaptureSession()
    private weak var presentationController: UIViewController?
    private weak var delegate: BarcodeReaderDelegate?
    private var permissions: Permissions

    init(presentationController: UIViewController,
         delegate: BarcodeReaderDelegate,
         permissions: Permissions) {
        self.presentationController = presentationController
        self.delegate = delegate
        self.permissions = permissions
        super.init()
        self.checkCameraPermission()
    }
    
    func stopCameraLiveView() {
        captureSession.stopRunning()
    }

    /// Checks if the user granted permission to use the camera
    private func checkCameraPermission() {
        permissions.requestCameraPermissions { [weak self] granted in
            DispatchQueue.main.async {
                granted ? self?.setupCameraLiveView() : self?.delegate?.presentError(with: .restrictedAccess)
            }
        }
    }
    
    // MARK: - Private functions
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
                  delegate?.presentError(with: .noCamera)
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
    // MARK: Overlay
    private func configurePreviewLayer() {
        DispatchQueue.main.async {
            let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            cameraPreviewLayer.videoGravity = .resizeAspectFill
            cameraPreviewLayer.connection?.videoOrientation = .portrait
            if let controller = self.presentationController as? BarcodeScanViewController {
                cameraPreviewLayer.frame = controller.mainView.videoPreviewContainerView.bounds
                controller.mainView.videoPreviewContainerView.layer.insertSublayer(cameraPreviewLayer, at: 0)
                controller.mainView.animationView.play()
            }
        }
    }
    // MARK: Vision
    /// Analyze the result of the handled request.
    /// - Get a list of potential barcodes from the request.
    /// - Loop through the potential barcodes to analyze each one individually.
    /// - A positive result is passed back to the previous view controller
    /// - Parameter request: VNDetectBarcodesRequest from detectBarcodeRequest
    private func processClassification(_ request: VNRequest) {
        guard let barcodes = request.results else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                    self.captureSession.isRunning else { return }
            
            self.presentationController?.view.layer.sublayers?.removeSubrange(1...)
            for barcode in barcodes {
                guard let potentialQRCode = barcode as? VNBarcodeObservation,
                      potentialQRCode.symbology != .QR,
                      potentialQRCode.confidence > 0.9 else { return }
                self.delegate?.provideBarcode(with: potentialQRCode.payloadStringValue)
            }
        }
    }
}
// MARK: - AVCaptureDelegation
extension BarcodeReader: AVCaptureVideoDataOutputSampleBufferDelegate {
    /// Get an image out of sample buffer, like a page out of a flip book.
    /// - Make a new VNImageRequestHandler using that image.
    /// - Perform the detectBarcodeRequest using the handler.
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right)
        do {
            try imageRequestHandler.perform(
                [VNDetectBarcodesRequest(completionHandler: { [weak self] request, error in
                    guard let self = self else { return }
                    if let error = error {
                        self.delegate?.presentError(with: .defaultError(error))
                        return
                    }
                    self.processClassification(request)
                })])
        } catch {
            print(error.localizedDescription)
        }
    }
}
