//
//  VideoFilterViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/21.
//

import UIKit
import CoreImage
import QuickLookThumbnailing
import AVFoundation

class VideoFilterViewModel: ObservableObject {
    struct FileExportError: Error {}
    struct AVAssetExportSessionError: Error {}
    var filterType: VideoFilterView.FilterType = .none
    
    @Published var thumbnails: [UIImage] = []
    @Published var filteredVideoURL: URL? = nil
    
    @Published var videoComposition: AVVideoComposition?
    
    private func customizedFilter(filter: CIFilter, type: VideoFilterView.FilterType) -> CIFilter {
        let filter = filter
        switch type {
        case .none:
            break
        case .colorClamp:
            filter.setValue(CIVector(x: 1, y: 1, z: 1, w: 0.5), forKey: "inputMaxComponents")
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputMinComponents")
        case .sepiaTone:
            break
        case .gaussianBlur:
            filter.setValue(5, forKey: kCIInputRadiusKey)
        case .vignetteEffect:
            break
        case .toneCurve:
            filter.setValue(CIVector(x: 0.0,  y: 1.0), forKey: "inputPoint0")
            filter.setValue(CIVector(x: 0.25, y: 0.75), forKey: "inputPoint1")
            filter.setValue(CIVector(x: 0.5,  y: 0.5), forKey: "inputPoint2")
            filter.setValue(CIVector(x: 0.75, y: 0.25), forKey: "inputPoint3")
            filter.setValue(CIVector(x: 1.0,  y: 0.0), forKey: "inputPoint4")
        }
        return filter
    }
    
    func createThumbnails(url: URL, thumbnailSize: CGSize, screenScale: CGFloat) async {
        guard let rawThumbnail = await fetchRawThumbnail(url: url, thumbnailSize: thumbnailSize, screenScale: screenScale) else { return }
        let thumbnails: [UIImage] = VideoFilterView.FilterType.allCases.map { type -> UIImage in
            guard type != .none else {
                return rawThumbnail
            }
            let inputImage = CIImage(image: rawThumbnail)
            let filter = customizedFilter(filter: CIFilter(name: type.rawValue,
                                                 parameters: [kCIInputImageKey: inputImage!])!, type: type)
            guard let outputImage = filter.outputImage,
                  let cgImage = CIContext(options: nil).createCGImage(outputImage, from: outputImage.extent) else { return rawThumbnail }
            return UIImage(cgImage: cgImage)
        }
        DispatchQueue.main.async {
            self.thumbnails = thumbnails
        }
    }
    
    private func fetchRawThumbnail(url: URL, thumbnailSize: CGSize, screenScale: CGFloat) async -> UIImage? {
        let request = QLThumbnailGenerator.Request(fileAt: url,
                                                   size: thumbnailSize,
                                                   scale: screenScale,
                                                   representationTypes: .thumbnail)
        return await withCheckedContinuation({ continuation in
            QLThumbnailGenerator.shared.generateRepresentations(for: request) { (thumbnail, type, error) in
                guard let thumbnail = thumbnail, error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                guard thumbnail.type == .thumbnail else {
                    return
                }
                continuation.resume(returning: thumbnail.uiImage)
            }
        })
    }
    
    func selectFilter(url: URL, type: VideoFilterView.FilterType) {
        guard type != filterType else {
            return
        }
        setVideoComposition(url: url, type: type)
        self.filterType = type
    }
    
    func setVideoComposition(url: URL, type: VideoFilterView.FilterType) {
        guard type != .none else {
            videoComposition = nil
            return
        }
        let asset = AVURLAsset(url: url)
        let filter = customizedFilter(filter: CIFilter(name: type.rawValue)!, type: type)
        let videoComposition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            filter.setValue(source, forKey: kCIInputImageKey)
            let output = filter.outputImage!.cropped(to: request.sourceImage.extent)
            request.finish(with: output, context: nil)
        })
        self.videoComposition = videoComposition
    }
    
    func writeFilteredVideo(url: URL) async -> Result<URL?, Error> {
        guard filterType != .none, let videoComposition = videoComposition else { return .success(nil) }
        return await withCheckedContinuation { continuation in
            let asset = AVURLAsset(url: url)
            guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPreset1280x720) else {
                continuation.resume(returning: .failure(AVAssetExportSessionError()))
                return
            }
            session.videoComposition = videoComposition
            session.outputURL = URL.exportURL()
            session.outputFileType = .mp4
            session.exportAsynchronously {
                switch session.status {
                case .completed:
                    if let url = session.outputURL {
                        continuation.resume(returning: .success(url))
                    } else {
                        continuation.resume(returning: .failure(FileExportError()))
                    }
                case .failed:
                    continuation.resume(returning: .failure(FileExportError()))
                default:
                    break
                }
            }
        }
    }
    
    
}
