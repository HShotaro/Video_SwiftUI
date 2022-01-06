//
//  VideoFilmingViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/09.
//

import Foundation
import Photos
import PhotosUI
import QuickLookThumbnailing

class VideoSelectionViewModel: ObservableObject {
    @Published var photoPickerModels = [PhotoPickerModel]()
    @Published var isEditing: Bool = false
    @Published var displayMode: VideoSelectionView.DisplayMode = .library
    @Published var isPHPhotoPickerViewPresented = false
    
    
    func getPHPickerResults(results: [PHPickerResult]) {
        // PHPhotoPickerViewでCancelボタンを押した時は実行しない
        guard results.count > 0 else { return }
        photoPickerModels = []
        results.forEach { result in
            getVideo(from: result.itemProvider, typeIdentifier: UTType.movie.identifier)
        }
    }
    private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { [weak self] url, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let url = url else { return }
                
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { throw NSError() }
                
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                
                try FileManager.default.copyItem(at: url, to: targetURL)
                self?.getThumbnail(targetURL: targetURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getThumbnail(targetURL: URL) {
        let size: CGSize = CGSize(width: 220, height: 220)
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: targetURL,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .all)
        
        QLThumbnailGenerator.shared.generateRepresentations(for: request) { [weak self] (thumbnail, type, error) in
            DispatchQueue.main.async {
                guard let thumbnail = thumbnail, error == nil else { return }
                guard thumbnail.type == .thumbnail || thumbnail.type == .lowQualityThumbnail else { return }
                self?.photoPickerModels.append(PhotoPickerModel(with: targetURL, photo: thumbnail.uiImage))
            }
        }
    }
}
