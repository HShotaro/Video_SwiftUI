//
//  url+delete.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/25.
//

import Foundation

extension URL {
    struct FileDeleteError: Error {}
    func delete() async throws -> Void {
        do {
            return try await withCheckedThrowingContinuation { continuation in
                do {
                    if FileManager.default.fileExists(atPath: self.path) {
                        try FileManager.default.removeItem(at: self)
                        continuation.resume(returning: ())
                    }
                } catch {
                    continuation.resume(throwing: FileDeleteError())
                }
            }
        } catch {
            throw error
        }
    }
}
