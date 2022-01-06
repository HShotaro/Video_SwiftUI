//
//  MypageViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/06.
//

import Foundation

class MyVideoViewModel: ObservableObject {
    @Published var videoURLs = [URL]()
    @Published var selectedVideos = [URL]()
    @Published var onEditing = false {
        didSet {
            if onEditing {
                 
            } else {
                selectedVideos = []
            }
        }
    }
    
    func refreshVideoURLs() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            // Documentから動画ファイルのURLを取得
            videoURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil)
        } catch {
            videoURLs = []
        }
    }
    
    func deleteVideos() {
        do {
            for selectedVideo in selectedVideos {
                try FileManager.default.removeItem(at: selectedVideo)
            }
            self.selectedVideos = []
            refreshVideoURLs()
        } catch {
            
        }
    }
    
    func toggleSelectedVideoState(selectedVideo: URL) {
        if selectedVideos.contains(selectedVideo) {
            guard let index = selectedVideos.firstIndex(of: selectedVideo) else { return }
            self.selectedVideos.remove(at: index)
        } else {
            self.selectedVideos.append(selectedVideo)
        }
    }
}
