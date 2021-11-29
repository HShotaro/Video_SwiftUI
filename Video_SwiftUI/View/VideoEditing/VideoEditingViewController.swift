//
//  VideoEditingViewController.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/22.
//

import UIKit
import AVKit

class VideoEditingViewController: UIViewController {
    private let playerItem:AVPlayerItem
    private let avplayer:AVPlayer
    private let playerLayer:AVPlayerLayer
    
    private let playOrStopButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        return button
    }()
    
    private let trimingView: TrimingView = {
        let v = TrimingView(frame: .zero)
        
        return v
    }()
    
    init(url: URL) {
        playerItem = AVPlayerItem(url: url)
        avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer.init(player: avplayer)
        super.init(nibName: nil, bundle: nil)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playOrStopButton.addTarget(self, action: #selector(playOrStop), for: .touchUpInside)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(VideoEditingViewController.didFinishPlayingVideo(_:)),name: .AVPlayerItemDidPlayToEndTime,object: playerItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(playerLayer, at: 0)
        view.addSubview(playOrStopButton)
        view.addSubview(trimingView)
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
                play()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 80)
        playOrStopButton.frame = CGRect(x: (view.bounds.width - 44) / 2, y: (view.bounds.height - 44) / 2 - 40, width: 44, height: 44)
        trimingView.frame = CGRect(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
    }
    
    @objc private func playOrStop(_ sender: UIButton) {
        guard playerLayer.player?.currentItem?.duration != playerLayer.player?.currentTime() else {
            // 最後まで見終わった時呼ばれる
            playerLayer.player?.currentItem?.seek(to: CMTime.zero, completionHandler: { [weak self] completion in
                if completion {
                    self?.play()
                }
            })
            return
        }
        
        let rate = avplayer.rate
        // 再生・停止の状態を切り替える
        if rate == 0.0 {
            self.play()
        } else if rate == 1.0 {
            self.pause()
        }
        
    }
    
    @objc private func didFinishPlayingVideo(_ notification: NSNotification) {
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 25))
        let image = UIImage(systemName: "gobackward", withConfiguration: imageConfig)
        playOrStopButton.setImage(image, for: .normal)
    }
    
    private func play() {
        avplayer.play()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 25))
        let image = UIImage(systemName: "pause", withConfiguration: imageConfig)
        playOrStopButton.setImage(image, for: .normal)
    }
    
    private func pause() {
        avplayer.pause()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 25))
        let image = UIImage(systemName: "play", withConfiguration: imageConfig)
        playOrStopButton.setImage(image, for: .normal)
    }
}
