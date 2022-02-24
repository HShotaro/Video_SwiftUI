//
//  SpriteKitView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/02/24.
//

import SwiftUI

struct VSSpriteKitView: UIViewControllerRepresentable {
    let url: URL
    typealias UIViewControllerType = VSSpriteKitViewController
    func makeUIViewController(context: Context) -> VSSpriteKitViewController {
        let spriteKitVC = VSSpriteKitViewController(url: url)
        spriteKitVC.delegate = context.coordinator
        return spriteKitVC
    }
    
    func updateUIViewController(_ uiViewController: VSSpriteKitViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    final class Coordinator: NSObject, VSSpriteKitViewControllerDelegate {
        private let spriteKitView: VSSpriteKitView
        init(_ spriteKitView: VSSpriteKitView) {
            self.spriteKitView = spriteKitView
        }
    }
}

struct VSSpriteKitView_Previews: PreviewProvider {
    static var previews: some View {
        VSSpriteKitView(url: URL(string: "")!)
    }
}
