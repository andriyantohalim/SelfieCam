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
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 60, height: 60)
                        )
                }
                .padding(.bottom, 30)
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

#Preview {
    SelfieCamView()
}
