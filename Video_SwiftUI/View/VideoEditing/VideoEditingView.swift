//
//  VideoEditingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/11.
//

import SwiftUI
import AVKit

struct VideoEditingView: UIViewControllerRepresentable {
    typealias UIViewControllerType = VideoEditingViewController
    let url: URL
    func makeUIViewController(context: Context) -> VideoEditingViewController {
        let videoEditingVC = VideoEditingViewController(url: url)
        
        return videoEditingVC
    }
    
    func updateUIViewController(_ uiViewController: VideoEditingViewController, context: Context) {
        
    }
}

struct VideoEditingView_Previews: PreviewProvider {
    static var previews: some View {
        VideoEditingView(url: URL(string: "")!)
    }
}
