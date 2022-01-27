//
//  MypageViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/06.
//

import Foundation
import SwiftUI

class MyVideoViewModel: ObservableObject {
    struct URLNotFoundError: Error {}
    private let viewContext = PersistenceController.shared.container.viewContext
    @Published var selectedVideos = [Video]()
    @Published var onEditing = false {
        didSet {
            if onEditing {
                 
            } else {
                selectedVideos = []
            }
        }
    }
    
    func deleteVideos() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            
            do {
                for selectedVideo in selectedVideos {
                    guard let url = URL(string: selectedVideo.urlString ?? "") else {
                        continuation.resume(throwing: URLNotFoundError() )
                        return
                    }
                    if FileManager.default.fileExists(atPath: url.path) {
                        try FileManager.default.removeItem(at: url)
                    }
                }
                try withAnimation {
                    selectedVideos.forEach(viewContext.delete)
                    try viewContext.save()
                    onEditing = false
                }
                continuation.resume(returning: ())
            } catch {
                print(error)
                continuation.resume(throwing: error)
            }
        }
    }
    
    func toggleSelectedVideoState(selectedVideo: Video) {
        if selectedVideos.contains(selectedVideo) {
            guard let index = selectedVideos.firstIndex(of: selectedVideo) else { return }
            self.selectedVideos.remove(at: index)
        } else {
            self.selectedVideos.append(selectedVideo)
        }
    }
}
