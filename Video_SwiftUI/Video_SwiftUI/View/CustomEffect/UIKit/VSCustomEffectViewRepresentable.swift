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
        VSCustomEffectViewRepresentable(playerItem: AVPlayerItem(url: URL(string: "file:///Users/s.hirano/Library/Developer/CoreSimulator/Devices/478B0B86-EE42-47C7-BA65-84C285C768ED/data/Containers/Shared/AppGroup/C5238E37-D733-4510-BF0E-EB01D63E723A/File%20Provider%20Storage/photospicker/version=1&uuid=EA5175EE-C703-49B5-80BE-05072235A56F&mode=current.mp4")!))
    }
}
