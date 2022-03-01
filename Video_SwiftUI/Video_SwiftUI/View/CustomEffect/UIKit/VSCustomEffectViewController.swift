//
//  VSCustomEffectViewController.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/02/24.
//

import UIKit
import AVKit
import SpriteKit

protocol VSCustomEffectViewControllerDelegate: AnyObject {
    
}

class VSCustomEffectViewController: UIViewController {
    private let playerLayer: AVPlayerLayer
    private let skView: SKView
    private let scene: SKScene
    
    init(playerItem: AVPlayerItem) {
        let playerItem = playerItem
        let avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avplayer)
        skView = SKView(frame: .zero)
        skView.allowsTransparency = true
        scene = ChocolateScene()
        scene.backgroundColor = .clear
        scene.scaleMode = .fill
        super.init(nibName: nil, bundle: nil)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    weak var delegate: VSCustomEffectViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(playerLayer, at: 0)
        view.addSubview(skView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.dominantColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerLayer.frame = view.bounds
        skView.frame = view.bounds
        skView.scene?.size = view.bounds.size
        skView.presentScene(scene)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(AVPlayerItem.status):
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                playerLayer.player?.play()
            case .failed:
                break
            case .unknown:
                break
            @unknown default:
                break
            }
        default:
            break
        }
    }
}
