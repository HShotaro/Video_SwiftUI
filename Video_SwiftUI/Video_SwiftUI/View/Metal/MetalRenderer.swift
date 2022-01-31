//
//  MetalRenderer.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/31.
//

import Foundation
import MetalKit

class MetalRenderer: NSObject, MTKViewDelegate {
    let parent: MetalView
    var commandQueue: MTLCommandQueue?
    var pipelineState: MTLRenderPipelineState?
    var viewportSize: CGSize = CGSize()
    var vertices: [ShaderVertex] = [ShaderVertex]()
    
    init(_ parent: MetalView) {
        self.parent = parent
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize = size
        let wh = Float(min(size.width, size.height))
        self.vertices = [
            ShaderVertex(position: vector_float2(x: 0.0, y: wh / 4.0), color: vector_float4(1.0, 0.0, 0.0, 1.0)),
            ShaderVertex(position: vector_float2(x: -wh / 4.0, y: -wh / 4.0), color: vector_float4(0.0, 1.0, 0.0, 1.0)),
            ShaderVertex(position: vector_float2(x: wh / 4.0, y: -wh / 4.0), color: vector_float4(0.0, 0.0, 1.0, 1.0))
        ]
    }
    
    func draw(in view: MTKView) {
        guard let cmdBuffer = self.commandQueue?.makeCommandBuffer() else { return }
        guard let renderPassDesc = view.currentRenderPassDescriptor else { return }
        guard let encoder = cmdBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc) else { return }
        
        encoder.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(self.viewportSize.width), height: Double(self.viewportSize.height), znear: 0.0, zfar: 1.0))
        
        if let pipeline = self.pipelineState {
            encoder.setRenderPipelineState(pipeline)
            encoder.setVertexBytes(self.vertices, length: MemoryLayout<ShaderVertex>.size * self.vertices.count, index: kShaderVertexInputIndexVertices)
            var vpSize = vector_float2(Float(self.viewportSize.width / 2.0) , Float(self.viewportSize.height / 2.0))
            encoder.setVertexBytes(&vpSize, length: MemoryLayout<vector_float2>.size, index: kShaderVertexInputIndexViewportSize)
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        }
        
        encoder.endEncoding()
        
        if let drawable = view.currentDrawable {
            cmdBuffer.present(drawable)
        }
        
        cmdBuffer.commit()
    }
    
    func setUp(device: MTLDevice, view: MTKView) {
        self.commandQueue = device.makeCommandQueue()
        setUpPipelineState(device: device, view: view)
    }
    
    func setUpPipelineState(device: MTLDevice, view: MTKView) {
        guard let library = device.makeDefaultLibrary() else { return }
        guard let vertexFunc = library.makeFunction(name: "vertexShader"),
        let fragmentFunc = library.makeFunction(name: "fragmentShader") else { return }
        
        let pipelineStateDesc = MTLRenderPipelineDescriptor()
        pipelineStateDesc.label = "Triangle Pipeline"
        pipelineStateDesc.vertexFunction = vertexFunc
        pipelineStateDesc.fragmentFunction = fragmentFunc
        pipelineStateDesc.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDesc)
        } catch let error {
           print(error)
        }
    }
}
