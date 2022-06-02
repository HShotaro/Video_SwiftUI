//
//  CustomEffectViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/26.
//

import Foundation
import AVFoundation
import PhotosUI

class CustomEffectViewModel: ObservableObject {
    @Published var isPHPhotoPickerViewPresented = false
    @Published var videoURL: URL?
    @Published var videoComposition: AVVideoComposition?
    
    func getPHPickerResult(_ result: PHPickerResult) {
        let itemProvider = result.itemProvider
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
                do {
                    guard let url = url, error == nil else {
                        throw error ?? NSError(domain: NSFileProviderErrorDomain, code: -1)
                    }
                    let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                    try? FileManager.default.removeItem(at: localURL)
                    try FileManager.default.copyItem(at: url, to: localURL)
                    DispatchQueue.main.async { [weak self] in
                        self?.videoURL = localURL
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
