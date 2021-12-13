//
//  TrimmingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/25.
//

import UIKit
import AVFoundation

protocol TrimingViewDelegate: AnyObject {
    func startPointViewdidEndDragging(seconds: Double)
    func currentPointViewDidUpdateFrame(seconds: Double)
    func endPointViewdidEndDragging(seconds: Double)
}

class TrimingView: UIView {
    static let height: CGFloat = 80
    
    private let horizontalMargin: CGFloat = 40
    private let sidePointViewWidth: CGFloat = 20
    private let currentPointViewWidth: CGFloat = 12
    private let thumbnailParentView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        return v
    }()
    
    private let currentPointView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.borderWidth = 5.5
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.masksToBounds = true
        return v
    }()
    
    private let startPointView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemPink
        return v
    }()
    
    private let endPointView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemPink
        return v
    }()
    
    private let leftMaskView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.alpha = 0.4
        return v
    }()
    
    private let rightMaskView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.alpha = 0.4
        return v
    }()
    
    private let leftPanGesture = UIPanGestureRecognizer()
    private let rightPanGesture = UIPanGestureRecognizer()
    private let currentPanGesture = UIPanGestureRecognizer()
    
    
    private lazy var startPointInitialCenterX: CGFloat = horizontalMargin + sidePointViewWidth / 2
    private lazy var endPointInitialCenterX: CGFloat = self.frame.width - horizontalMargin - sidePointViewWidth / 2
    private lazy var currentPointInitialCenterX: CGFloat = horizontalMargin + sidePointViewWidth / 2
    
    private let assetDuration: Float64
    
    var isCurrentPointViewDragging = false
    weak var delegate: TrimingViewDelegate?
    
    init(frame: CGRect, avAsset: AVAsset, duration: Float64) {
        assetDuration = duration
        super.init(frame: frame)
        addSubview(thumbnailParentView)
        addSubview(leftMaskView)
        addSubview(rightMaskView)
        addSubview(startPointView)
        addSubview(endPointView)
        addSubview(currentPointView)
        
        leftPanGesture.addTarget(self, action: #selector(pan(_:)))
        startPointView.addGestureRecognizer(leftPanGesture)
        rightPanGesture.addTarget(self, action: #selector(pan(_:)))
        endPointView.addGestureRecognizer(rightPanGesture)
        currentPanGesture.addTarget(self, action: #selector(pan(_:)))
        currentPointView.addGestureRecognizer(currentPanGesture)
        
        generateVideoImages(avAsset: avAsset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pan(_ sender: UIPanGestureRecognizer) {
        let transitionX = sender.translation(in: self).x
        switch sender {
        case leftPanGesture:
            switch sender.state {
            case .began:
                self.startPointInitialCenterX = sender.view?.center.x ?? 0
            case .cancelled:
                sender.view?.center.x = startPointInitialCenterX
            default:
                let newCenterX = startPointInitialCenterX + transitionX
                let x = min(endPointInitialCenterX - sidePointViewWidth, max(horizontalMargin + sidePointViewWidth / 2, newCenterX))
                startPointView.center.x = x
                if sender.state == .ended {
                    leftMaskView.frame = CGRect(x: 0, y: 0, width: x, height: self.frame.height)
                    self.startPointInitialCenterX = x
                    let startPointRatio: CGFloat = (startPointInitialCenterX - horizontalMargin - sidePointViewWidth / 2) / (self.frame.width - horizontalMargin * 2 - sidePointViewWidth)
                    self.delegate?.startPointViewdidEndDragging(seconds: startPointRatio * Double(assetDuration))
                }
            }
        case rightPanGesture:
            switch sender.state {
            case .began:
                self.endPointInitialCenterX = sender.view?.center.x ?? 0
            case .cancelled:
                sender.view?.center.x = endPointInitialCenterX
            default:
                let newCenterX = endPointInitialCenterX + transitionX
                let x = max(startPointInitialCenterX + sidePointViewWidth, min(self.frame.width - horizontalMargin - sidePointViewWidth / 2, newCenterX))
                endPointView.center.x = x
                if sender.state == .ended {
                    rightMaskView.frame = CGRect(x: x, y: 0, width: self.frame.width - x, height: self.frame.height)
                    self.endPointInitialCenterX = x
                    let endPointRatio: CGFloat = (endPointInitialCenterX - horizontalMargin - sidePointViewWidth / 2) / (self.frame.width - horizontalMargin * 2 - sidePointViewWidth)
                    self.delegate?.endPointViewdidEndDragging(seconds: endPointRatio * Double(assetDuration))
                }
            }
        case currentPanGesture:
            switch sender.state {
            case .began:
                self.currentPointInitialCenterX = sender.view?.center.x ?? 0
                self.isCurrentPointViewDragging = true
            case .cancelled:
                sender.view?.center.x = currentPointInitialCenterX
                self.isCurrentPointViewDragging = false
            default:
                let newCenterX = currentPointInitialCenterX + transitionX
                let x = max(startPointInitialCenterX, min(endPointInitialCenterX, newCenterX))
                currentPointView.center.x = x
                if sender.state == .ended {
                    self.currentPointInitialCenterX = x
                    self.isCurrentPointViewDragging = false
                }
                
                let currentRatio: CGFloat = (x - horizontalMargin - sidePointViewWidth / 2) / (self.frame.width - horizontalMargin * 2 - sidePointViewWidth)
                self.delegate?.currentPointViewDidUpdateFrame(seconds: currentRatio * Double(assetDuration))
            }
        default:
            break
        }
    }
    
    
    private var numberOfThumbnails: Int = 1
    private var thumbnails: [(requestSeconds: Double, thumbnail: UIImageView)] = [] {
        didSet {
            if thumbnails.count == numberOfThumbnails {
                let t = thumbnails.sorted { a, b in
                    a.requestSeconds < b.requestSeconds
                }.map { $0.thumbnail }
                updateThumbnailFrame(thumbnails: t)
            }
        }
    }
    
    private func generateVideoImages(avAsset: AVAsset) {
        let imageGenerator = AVAssetImageGenerator.init(asset: avAsset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 200, height: TrimingView.height)
        
        if assetDuration < 20 {
            numberOfThumbnails = 5
        } else if assetDuration < 60 {
            numberOfThumbnails = 10
        } else {
            numberOfThumbnails = 15
        }
        
        let p = assetDuration / Double(numberOfThumbnails)
        
        var times: [NSValue] = []
        var start: Float64 = 0.0
        
        for _ in 1...numberOfThumbnails {
            let time = CMTimeMakeWithSeconds(start, preferredTimescale: Int32(NSEC_PER_SEC))
            start += p
            times += [NSValue(time: time)]
        }
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { [weak self] requestedTime, image, actualTime, result, error in
            guard let `self` = self else { return }
            switch result {
            case .succeeded:
                DispatchQueue.main.async() { [weak self] in
                    guard let _image = image else { return }
                    let imageView = UIImageView(image: UIImage(cgImage: _image))
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    self?.thumbnailParentView.addSubview(imageView)
                    self?.thumbnails.append((requestSeconds: requestedTime.seconds, thumbnail: imageView))
                }
            case .failed, .cancelled:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func updateThumbnailFrame(thumbnails: [UIImageView]) {
        let height = self.frame.height
        let width = self.frame.width - horizontalMargin * 2 - sidePointViewWidth * 2
        let itemWidth = width / CGFloat(numberOfThumbnails)
        thumbnails.enumerated().forEach { (index, thumbnail) in
            thumbnail.frame = CGRect(x: horizontalMargin + sidePointViewWidth + CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: height)
        }
    }
    
    func updateCurrentPointView(seconds: Double) {
        let currentRatio = CGFloat(seconds / Double(assetDuration))
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let x = self.horizontalMargin + self.sidePointViewWidth / 2 + currentRatio * (self.frame.width - self.horizontalMargin * 2 - self.sidePointViewWidth)
            self.currentPointInitialCenterX = x
            self.currentPointView.center.x = x
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        let width = self.frame.width
        thumbnailParentView.frame = self.bounds
        leftMaskView.frame = CGRect(x: 0, y: 0, width: startPointInitialCenterX, height: height)
        startPointView.frame = CGRect(x: startPointInitialCenterX - sidePointViewWidth / 2, y: 0, width: sidePointViewWidth, height: height)
        endPointView.frame = CGRect(x: endPointInitialCenterX - sidePointViewWidth / 2, y: 0, width: sidePointViewWidth, height: height)
        rightMaskView.frame = CGRect(x: endPointInitialCenterX, y: 0, width: width - endPointInitialCenterX, height: height)
        currentPointView.frame = CGRect(x: currentPointInitialCenterX - currentPointViewWidth / 2, y: 0, width: currentPointViewWidth, height: height)
    }
}
