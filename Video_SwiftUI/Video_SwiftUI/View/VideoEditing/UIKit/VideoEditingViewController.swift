//
//  VideoEditingViewController.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/22.
//

import UIKit
import AVKit

protocol VideoEditingViewControllerDelegate: AnyObject {
    func currentAVAssetStartPointDidChange(seconds: Double)
    func currentAVAssetEndPointDidChange(seconds: Double)
}

class VideoEditingViewController: UIViewController {
    private let playerItem:AVPlayerItem
    private let avplayer:AVPlayer
    private let playerLayer:AVPlayerLayer
    
    private let playOrStopButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        return button
    }()
    
    private let trimingView: TrimingView!
    
    
    var startTime: Double = 0.0
    var endTime: Double
    private var timeObserverToken: Any? = nil
    var isPlaying: Bool = false {
        didSet {
            guard isPlaying != oldValue else { return }
            if isPlaying {
                timeObserverToken = avplayer.addPeriodicTimeObserver(
                    forInterval:CMTime(seconds: 0.5,
                    preferredTimescale: naturalVideoScale),
                    queue: DispatchQueue.global()) { [weak self] time in
                        guard self?.trimingView.isCurrentPointViewDragging == false else { return }
                        guard time.seconds <= self?.endTime ?? 0.0 else {
                            DispatchQueue.main.async { [weak self] in
                                self?.didFinishPlayingVideo()
                                self?.trimingView.updateCurrentPointView(seconds: self?.endTime ?? 0)
                            }
                            return
                        }
                        guard time.seconds - (self?.startTime ?? 0.0) > 0.5 else {
                            self?.trimingView.updateCurrentPointView(seconds: self?.startTime ?? 0.0)
                            return
                        }
                        self?.trimingView.updateCurrentPointView(seconds: time.seconds)
                }
            } else {
                timeObserverToken = nil
            }
        }
    }
    
    let naturalVideoScale: CMTimeScale
    
    weak var delegate: VideoEditingViewControllerDelegate?
    
    init(url: URL) {
        let avAsset = AVAsset(url: url)
        let duration = CMTimeGetSeconds(avAsset.duration)
        self.naturalVideoScale = avAsset.tracks(withMediaType: .video).first?.naturalTimeScale ?? CMTimeScale(NSEC_PER_SEC)
        trimingView = TrimingView.init(frame: .zero, avAsset: avAsset, duration: duration)
        playerItem = AVPlayerItem(url: url)
        endTime = Double(duration)
        avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer.init(player: avplayer)
        super.init(nibName: nil, bundle: nil)
        trimingView.delegate = self
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playOrStopButton.addTarget(self, action: #selector(playOrStop), for: .touchUpInside)
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new], context: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(VideoEditingViewController.didFinishPlayingVideo),name: .AVPlayerItemDidPlayToEndTime,object: playerItem)
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
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - TrimingView.height)
        playOrStopButton.frame = CGRect(x: (view.bounds.width - 44) / 2, y: (view.bounds.height - 44) / 2 - 40, width: 44, height: 44)
        trimingView.frame = CGRect(x: view.safeAreaInsets.left, y: view.bounds.height - TrimingView.height, width: view.frame.width - view.safeAreaInsets.left - view.safeAreaInsets.right, height: TrimingView.height)
    }
    
    @objc private func playOrStop(_ sender: UIButton) {
        guard endTime > playerLayer.player?.currentTime().seconds ?? 0.0 else {
            // 最後まで見終わった時呼ばれる
            playerLayer.player?.currentItem?.seek(to: CMTime(seconds: startTime, preferredTimescale: naturalVideoScale), completionHandler: { [weak self] completion in
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
    
    @objc private func didFinishPlayingVideo() {
        avplayer.pause()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 25))
        let image = UIImage(systemName: "gobackward", withConfiguration: imageConfig)
        playOrStopButton.setImage(image, for: .normal)
        self.isPlaying = false
    }
    
    private func play() {
        avplayer.play()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 25))
        let image = UIImage(systemName: "pause", withConfiguration: imageConfig)
        playOrStopButton.setImage(image, for: .normal)
        self.isPlaying = true
    }
    
    func pause() {
        avplayer.pause()
        let imageConfig = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 25))
        let image = UIImage(systemName: "play", withConfiguration: imageConfig)
        playOrStopButton.setImage(image, for: .normal)
        self.isPlaying = false
    }
}

extension VideoEditingViewController: TrimingViewDelegate {
    func startPointViewdidEndDragging(seconds: Double) {
        self.startTime = seconds
        self.playerItem.seek(to: CMTime(seconds: seconds, preferredTimescale: naturalVideoScale), completionHandler: nil)
        self.delegate?.currentAVAssetStartPointDidChange(seconds: seconds)
    }
    
    func currentPointViewDidUpdateFrame(seconds: Double) {
        self.playerItem.seek(to: CMTime(seconds: seconds, preferredTimescale: naturalVideoScale), completionHandler: nil)
    }
    
    func endPointViewdidEndDragging(seconds: Double) {
        self.endTime = seconds
        self.delegate?.currentAVAssetEndPointDidChange(seconds: seconds)
        if endTime <= (playerLayer.player?.currentTime().seconds ?? 0.0) {
            playerLayer.player?.currentItem?.seek(to: CMTime(seconds: startTime, preferredTimescale: naturalVideoScale), completionHandler: { [weak self] completion in
                if completion {
                    self?.play()
                }
            })
            return
        }
    }
}
