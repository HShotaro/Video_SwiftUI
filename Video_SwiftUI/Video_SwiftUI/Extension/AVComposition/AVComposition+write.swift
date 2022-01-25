//
//  AVComposition+write.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/25.
//

import Foundation
import AVFoundation

extension AVComposition {
    struct FileExportError: Error {}
    struct AVAssetExportSessionError: Error {}
    func write() async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            guard let session = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetPassthrough) else {
                continuation.resume(throwing: AVAssetExportSessionError())
                return
            }
            session.outputURL = URL.exportURL()
            session.outputFileType = .mp4
            session.exportAsynchronously {
                switch session.status {
                case .completed:
                    if let url = session.outputURL {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: FileExportError())
                    }
                case .failed:
                    continuation.resume(throwing: session.error ?? FileExportError())
                default:
                    break
                }
            }
        }
    }
}
