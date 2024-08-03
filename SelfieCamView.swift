//
//  SelfieCamView.swift
//  SelfieCam
//
//  Created by Andriyanto Halim on 3/8/24.
//

import SwiftUI
import AVFoundation

struct SelfieCamView: View {
    @ObservedObject var viewModel = SelfieCamViewModel()

    var body: some View {
        ZStack {
            CameraPreview(previewLayer: viewModel.getPreviewLayer())
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Button(action: {
                    viewModel.capturePhoto()
                }) {
                    Text("Capture")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.bottom, 30)
                }
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let previewLayer = previewLayer {
            previewLayer.frame = UIScreen.main.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
