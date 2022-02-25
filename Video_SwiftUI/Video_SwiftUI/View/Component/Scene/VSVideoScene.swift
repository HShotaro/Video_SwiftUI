//
//  VSVideoScene.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/02/24.
//

import Foundation
import SpriteKit

class VSVideoScene: SKScene {
    
    override func didMove(to view: SKView) {
//        物体が落下した時に下に積もるようにしたい時に使う
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = SKSpriteNode(imageNamed: "petal")
        node.position = location
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        let nodeName = "petal_" + UUID().uuidString
        node.name = nodeName
        addChild(node)
        rotate(nodeName: nodeName)
    }
    
    private func rotate(nodeName: String) {
        guard let petalNode = self.childNode(withName: nodeName) as? SKSpriteNode else { return }
        let action1 = SKAction.wait(forDuration: 0.2)
        let action2 = SKAction.rotate(byAngle: CGFloat(Double.pi * 5), duration: 1.0)
        //一定速度で回転する。
        action2.timingMode = SKActionTimingMode.linear
        let actionAll = SKAction.sequence([action1,action2])
        petalNode.run(actionAll)
    }
}
