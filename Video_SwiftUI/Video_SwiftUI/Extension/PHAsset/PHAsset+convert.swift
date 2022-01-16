//
//  PHAsset+convertToUIImage.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/16.
//

import UIKit
import Photos

struct PHAssetConvertError: Error {
    
}

extension PHAsset {
    func toAVAsset(options: PHVideoRequestOptions? = nil) async throws -> AVAsset {
        let manager: PHImageManager = PHImageManager()
        return try await withCheckedThrowingContinuation({ continuation in
            manager.requestAVAsset(forVideo: self, options: options) { avAsset, avAuvioMix, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard !(info?[PHImageCancelledKey] as? Bool ?? false) else {
                    continuation.resume(throwing: CancellationError())
                    return
                }
                guard !(info?[PHImageResultIsDegradedKey] as? Bool ?? false) else {
                    return
                }
                
                guard let avAsset = avAsset else {
                    continuation.resume(throwing: PHAssetConvertError())
                    return
                }
                continuation.resume(returning: avAsset)
            }
        })
    }
    
    func toUIImage() async throws -> UIImage {
        let manager: PHImageManager = PHImageManager()
        return try await withCheckedThrowingContinuation({ continuation in
            manager.requestImage(
                for: self,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFill,
                   options: nil) { image, info in
                       if let error = info?[PHImageErrorKey] as? Error {
                           continuation.resume(throwing: error)
                           return
                       }
                       
                       guard !(info?[PHImageCancelledKey] as? Bool ?? false) else {
                           continuation.resume(throwing: CancellationError())
                           return
                       }
                       guard !(info?[PHImageResultIsDegradedKey] as? Bool ?? false) else {
                           return
                       }
                       
                       guard let image = image else {
                           continuation.resume(throwing: PHAssetConvertError())
                           return
                       }
                       continuation.resume(returning: image)
            }
        })
    }
}
