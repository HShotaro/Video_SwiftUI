//
//  VSVideoScene.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/02/24.
//

import Foundation
import SpriteKit

class PetalScene: SKScene {
    
    override func didMove(to view: SKView) {
//        物体が落下した時に下に積もるようにしたい時に使う
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let petalNode = SKSpriteNode(imageNamed: "petal")
        petalNode.position = location
        petalNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        let nodeName = "petal_" + UUID().uuidString
        petalNode.name = nodeName
        addChild(petalNode)
        rotate(nodeName: nodeName)
    }
    
    private func rotate(nodeName: String) {
        guard let petalNode = self.childNode(withName: nodeName) as? SKSpriteNode else { return }
        let bigAction = SKAction.scale(by: 2.0, duration: 0.1)
        bigAction.timingMode = .easeIn
        let smallAction = SKAction.scale(by: 0.5, duration: 0.12)
        smallAction.timingMode = .easeOut
        let rotateAction = SKAction.rotate(byAngle: CGFloat(Double.pi * 4), duration: 1.0)
        //一定速度で回転する。
        rotateAction.timingMode = SKActionTimingMode.linear
        let waitingAction = SKAction.wait(forDuration: 2)
        let removeAction = SKAction.removeFromParent()
        let actionAll = SKAction.sequence([bigAction, smallAction, rotateAction, waitingAction, removeAction])
        petalNode.run(actionAll)
    }
}
