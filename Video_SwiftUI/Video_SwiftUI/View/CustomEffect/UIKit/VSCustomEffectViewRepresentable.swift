//
//  CustomEffectViewRepresentable.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/02/24.
//

import SwiftUI
import AVFoundation

struct VSCustomEffectViewRepresentable: UIViewControllerRepresentable {
    let playerItem: AVPlayerItem
    typealias UIViewControllerType = VSCustomEffectViewController
    func makeUIViewController(context: Context) -> VSCustomEffectViewController {
        let vc = VSCustomEffectViewController(playerItem: playerItem)
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: VSCustomEffectViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    final class Coordinator: NSObject, VSCustomEffectViewControllerDelegate {
        private let customEffectViewRepresentable: VSCustomEffectViewRepresentable
        init(_ customEffectViewRepresentable: VSCustomEffectViewRepresentable) {
            self.customEffectViewRepresentable = customEffectViewRepresentable
        }
    }
}

struct VSCustomEffectViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        VSCustomEffectViewRepresentable(playerItem: AVPlayerItem(url: URL(string: "")!))
    }
}
