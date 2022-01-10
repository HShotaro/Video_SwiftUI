//
//  VideoSaveViewModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/07.
//

import Foundation
import SwiftUI

class VideoSaveViewModel: ObservableObject {
    @Published var state = VideoSaveView.Stateful.editing
    private let viewContext = PersistenceController.shared.container.viewContext
    
    func addVideo(videoTitle: String, urlString: String) {
        let newVideo = Video(context: viewContext)
        newVideo.title = videoTitle
        newVideo.urlString = urlString
        newVideo.addedDate = Date()
        do {
            try viewContext.save()
            self.state = .uploaded
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            self.state = .uploadError(error)
        }
    }
}
