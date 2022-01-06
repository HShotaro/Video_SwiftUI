//
//  VideoEditingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/11.
//

import SwiftUI
import AVKit

struct VideoEditingViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = VideoEditingViewController
    @Binding var currentVideoAssetStartPoint: Double
    @Binding var currentVideoAssetEndPoint: Double?
    @Binding var isPushActive: Bool
    let url: URL
    func makeUIViewController(context: Context) -> VideoEditingViewController {
        let videoEditingVC = VideoEditingViewController(url: url)
        videoEditingVC.delegate = context.coordinator
        return videoEditingVC
    }
    
    func updateUIViewController(_ uiViewController: VideoEditingViewController, context: Context) {
        if isPushActive {
            uiViewController.pause()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, VideoEditingViewControllerDelegate {
        private let editingViewRepresentable: VideoEditingViewRepresentable
        init(_ editingViewRepresentable: VideoEditingViewRepresentable) {
            self.editingViewRepresentable = editingViewRepresentable
        }
        
        func currentAVAssetStartPointDidChange(seconds: Double) {
            editingViewRepresentable.currentVideoAssetStartPoint = seconds
        }
        
        func currentAVAssetEndPointDidChange(seconds: Double) {
            editingViewRepresentable.currentVideoAssetEndPoint = seconds
        }
    }
}

struct VideoEditingViewRepresentable_Previews: PreviewProvider {
    @State static var currentVideoAssetStartPoint: Double = 0.0
    @State static var currentVideoAssetEndPoint: Double? = 5.0
    @State static var isPushActive = false
    static var previews: some View {
        VideoEditingViewRepresentable(currentVideoAssetStartPoint: VideoEditingViewRepresentable_Previews.$currentVideoAssetStartPoint, currentVideoAssetEndPoint: VideoEditingViewRepresentable_Previews.$currentVideoAssetEndPoint, isPushActive: VideoEditingViewRepresentable_Previews.$isPushActive, url: URL(string: "")!)
    }
}
