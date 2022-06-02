//
//  _360DegreeScene.swift
//  Video_SwiftUI
//
//  Created by shotaro hirano on 2022/06/02.
//

import SwiftUI
import AVFoundation
import SceneKit
import SpriteKit

class _360DegreeScene: SCNScene {
    private let cameraNode: SCNNode
    private var playerLooper: AVPlayerLooper?
    
    override init() {
        cameraNode = SCNNode()
        super.init()
        
        cameraNode.camera = SCNCamera()
        cameraNode.orientation = .init(0, 1, 0, 0)
        self.rootNode.addChildNode(cameraNode)
        let urlPath = Bundle.main.path(forResource: "test360", ofType: "mp4")!
        let asset = AVAsset(url: URL(fileURLWithPath: urlPath))
        let playerItem = AVPlayerItem(asset: asset)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        queuePlayer.isMuted = true
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        let videoScene = SKScene(size: .init(width: 5760, height: 2880))
        let videoNode = SKVideoNode(avPlayer: queuePlayer)
        videoNode.position = .init(x: videoScene.size.width / 2.0, y: videoScene.size.height / 2.0)
        videoNode.size = videoScene.size
        videoNode.xScale = -1.0
        videoNode.yScale = -1.0
        videoNode.play()
        videoScene.addChild(videoNode)
        
        let sphere = SCNSphere(radius: 20)
        sphere.firstMaterial?.isDoubleSided = true
        sphere.firstMaterial?.diffuse.contents = videoScene
        let sphereNode = SCNNode(geometry: sphere)
        self.rootNode.addChildNode(sphereNode)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var currentDragVlaue: DragGesture.Value?
     
    func drag(value: DragGesture.Value) {
        if currentDragVlaue?.startLocation != value.startLocation { currentDragVlaue = nil }
        let dragX = value.location.x - (currentDragVlaue?.location.x ?? value.startLocation.x)
        let dragY = value.location.y - (currentDragVlaue?.location.y ?? value.startLocation.y)
        
        cameraNode.orientation = rotateCamera(
            q: cameraNode.orientation, // カメラの元々の姿勢
            point: cameraDragPoint(dragOffset: .init(x: dragX, y: dragY)) // ドラッグした距離を角度に変換
        )
        
        currentDragVlaue = value
    }
    
    /// スクロール幅のxy移動量を角度に変換
    private func cameraDragPoint(dragOffset: CGPoint) -> CGPoint {
        let angle = CGFloat(180)
        let x = (dragOffset.x / UIScreen.main.bounds.width) * angle
        let y = (dragOffset.y / UIScreen.main.bounds.height) * angle
        return .init(x: x, y: y)
    }
    
    /// カメラの回転値を取得
    private func rotateCamera(q: SCNQuaternion, point: CGPoint) -> SCNQuaternion {
        // カメラの元々の姿勢
        let current = GLKQuaternionMake(q.x, q.y, q.z, q.w)
        // y軸をドラッグのx移動量まで回転させる
        let width = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(Float(point.x)), 0, 1, 0)
        // x軸をドラッグのy移動量まで回転させる
        let height = GLKQuaternionMakeWithAngleAndAxis(GLKMathDegreesToRadians(Float(point.y)), 1, 0, 0)
        // 新しいカメラの姿勢を設定
        let qp  = GLKQuaternionMultiply(GLKQuaternionMultiply(width, current), height)
        return SCNQuaternion(qp.x, qp.y, qp.z, qp.w)
    }
}

