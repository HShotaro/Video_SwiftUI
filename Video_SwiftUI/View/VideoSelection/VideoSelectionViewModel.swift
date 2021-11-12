//
//  VideoFilmingViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/09.
//

import Foundation
import Photos
import Combine
import PhotosUI

class VideoSelectionViewModel: ObservableObject {
    @Published var photoPickerModels = [PhotoPickerModel]()
    @Published var isEditing: Bool = false
    @Published var displayMode: VideoSelectionView.DisplayMode = .library
    @Published var isPHPhotoPickerViewPresented = false
    @Published var showConfirmDialogOfSelectedPicture = false
    @Published var selectedVideo: PhotoPickerModel? = nil
    
    
    func getPHPickerResults(results: [PHPickerResult]) {
        // PHPhotoPickerViewでCancelボタンを押した時は実行しない
        guard results.count > 0 else { return }
        photoPickerModels = []
        results.forEach { result in
            getVideo(from: result.itemProvider, typeIdentifier: UTType.movie.identifier)
        }
    }
    private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let url = url else { return }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
            
            do {
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                
                try FileManager.default.copyItem(at: url, to: targetURL)
                
                DispatchQueue.main.async {
                    self.photoPickerModels.append(PhotoPickerModel(with: targetURL))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
