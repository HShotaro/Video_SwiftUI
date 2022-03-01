//
//  ChocolateScene.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/03/01.
//

import Foundation
import SpriteKit

class ChocolateScene: SKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let cgImage = UIImage(named: "chocolate")?.cgImage else { return }
        let skTexture = SKTexture(cgImage: cgImage)
        let fullTextureSize = skTexture.size()
        let textureSize = CGSize(width: 128, height: 128)
        let cols = Int(fullTextureSize.width / textureSize.width)
        let rows = Int(fullTextureSize.height / textureSize.height)
        
        var animationFrames = [SKTexture]()
        for rowIdx in 0..<rows {
            for colIdx in 0..<cols {
                let cutterX: CGFloat = (CGFloat(colIdx) * textureSize.width)/fullTextureSize.width
                let cutterY: CGFloat = CGFloat(rows - rowIdx - 1) * textureSize.height / fullTextureSize.height
                let cutterW: CGFloat = textureSize.width / fullTextureSize.width
                let cutterH: CGFloat = textureSize.height / fullTextureSize.height
                let cutterRect = CGRect(x: cutterX, y: cutterY, width: cutterW, height: cutterH)
                let subTexture = SKTexture(rect: cutterRect, in: skTexture)
                animationFrames.append(subTexture)
            }
        }
        
        guard animationFrames.indices.contains(0), cols * rows != 0 else { return }
        let node = SKSpriteNode(texture: animationFrames[0])
        let animationAction = SKAction.animate(with: animationFrames,
                                      timePerFrame: 0.05,
                                          resize: true,
                                          restore: false)
        
        let location = touch.location(in: self)
        node.position = location
        let nodeName = "chocolate"
        node.name = nodeName
        addChild(node)
        
        let removeAction = SKAction.removeFromParent()
        let actionAll = SKAction.sequence([animationAction, removeAction])
        node.run(actionAll)
    }
}
