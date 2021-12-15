//
//  VideoUploadViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/13.
//

import Foundation
import SwiftUI

class VideoUploadViewModel: ObservableObject {
    @Published var state: VideoUploadView.Stateful  = .editing
    
    func upload(videoURL: URL, videoTitle: String, description: String) async throws {
        do {
            let videoData = try Data(contentsOf: videoURL)
            try await VideoUploadRepository.upload(videoData: videoData, videoTitle: videoTitle, description: description)
            DispatchQueue.main.async { [weak self] in
                self?.state = .uploaded
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.state = .uploadError(error)
            }
        }
    }
}
