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
                if let avAsset = avAsset {
                    continuation.resume(returning: avAsset)
                } else {
                    continuation.resume(throwing: PHAssetConvertError())
                }
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
                       if let image = image {
                           continuation.resume(returning: image)
                       } else {
                           continuation.resume(throwing: PHAssetConvertError())
                       }
            }
        })
    }
}
