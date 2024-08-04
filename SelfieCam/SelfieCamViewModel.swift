//
//  SelfieCamViewModel.swift
//  SelfieCam
//
//  Created by Andriyanto Halim on 3/8/24.
//

import SwiftUI
import AVFoundation
import Photos

class SelfieCamViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var photoOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    @Published var capturedImage: UIImage?

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession?.addInput(input)
        } catch {
            print("Error setting up camera input: \(error)")
        }

        photoOutput = AVCapturePhotoOutput()
        if let photoOutput = photoOutput {
            captureSession?.addOutput(photoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspectFill

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.capturedImage = UIImage(data: imageData)
        savePhotoToLibrary(imageData)
    }

    private func savePhotoToLibrary(_ imageData: Data) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.forAsset().addResource(with: .photo, data: imageData, options: nil)
            }, completionHandler: nil)
        }
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
}
