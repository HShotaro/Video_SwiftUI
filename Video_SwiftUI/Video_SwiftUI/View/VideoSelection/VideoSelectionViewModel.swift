//
//  VideoFilmingViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/09.
//

import Foundation
import PhotosUI

class VideoSelectionViewModel: NSObject, ObservableObject {
    @Published var phAssetImages: [UIImage] = []
    @Published var isEditing: Bool = false
    @Published var displayMode: VideoSelectionView.DisplayMode = .library
    
    private var phAssets = [PHAsset]() {
        didSet {
            Task {
                do {
                    let images = try await PHAssetImages()
                    DispatchQueue.main.async { [weak self] in
                        self?.phAssetImages = images
                    }
                } catch {
                    
                }
            }
        }
    }
    
    
    func fetchPHAsset() async {
        var items: [PHAsset] = []
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let videoPredicate = NSPredicate(format: "mediaType= %d",   PHAssetMediaType.video.rawValue)
//        let imagePredicate = NSPredicate(format: "mediaType= %d", PHAssetMediaType.audio.rawValue)
//        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [videoPredicate, imagePredicate])
        options.predicate = videoPredicate
        
        let result = PHAsset.fetchAssets(with: options)
        return await withCheckedContinuation { continuation in
            guard result.count > 0 else {
                self.phAssets = []
                continuation.resume(returning: ())
                return
            }
            result.enumerateObjects(options: []) { (phAsset: PHAsset, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
                items.append(phAsset)
                if items.count >= result.count {
                    self.phAssets = items
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    private func PHAssetImages() async throws -> [UIImage] {
        var currentImages: [(image: UIImage?, index: Int)] = []
        let images: [UIImage] = try await withThrowingTaskGroup(of: (image: UIImage?, index: Int).self) { group -> [UIImage] in
            let phAssets = phAssets.enumerated().map { index, asset in
                return (image: asset, index: index)
            }
            for asset in phAssets {
                group.addTask {
                    let image = try await asset.image.toUIImage()
                    let thumbnail = image.resizeImage(targetRect: CGRect.init(origin: .zero, size: CGSize(width: min(asset.image.pixelWidth, 200), height: min(asset.image.pixelHeight, 200))))
                    return (image: thumbnail, index: asset.index)
                }
            }
            
            for try await t in group {
                currentImages.append(t)
            }
            let newImages: [UIImage] = currentImages.sorted { $0.index < $1.index }.compactMap { $0.image }
            return newImages
        }
        return images
    }
    
    func getVideoURL(selectedIndex: Int) async throws -> URL? {
        guard selectedIndex >= 0, selectedIndex < phAssets.count else {
            return nil
        }
        do {
            let avAsset = try await phAssets[selectedIndex].toAVAsset(options: nil)
            return (avAsset as? AVURLAsset)?.url
        } catch {
            return nil
        }
    }
}

extension VideoSelectionViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task {
            await fetchPHAsset()
        }
    }
}
