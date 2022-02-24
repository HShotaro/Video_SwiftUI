//

//  MetalVideoView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/31.
//
import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    typealias UIViewType = MTKView

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = MTLCreateSystemDefaultDevice()
        view.delegate = context.coordinator
        view.clearColor = MTLClearColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if let device = view.device {
            context.coordinator.setUp(device: device, view: view)
        }
        return view
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        
    }
    
    func makeCoordinator() -> MetalRenderer {
        return MetalRenderer(self)
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}
