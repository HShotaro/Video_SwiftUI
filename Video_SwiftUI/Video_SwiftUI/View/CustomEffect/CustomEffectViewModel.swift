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
        result.itemProvider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] fileURL, error in
            if let error = error {
                print(error.localizedDescription)
            }

            guard let url = fileURL as? URL else { return }
            print(url.absoluteString)
            DispatchQueue.main.async { [weak self] in
                self?.videoURL = url
            }
        }
    }

}
