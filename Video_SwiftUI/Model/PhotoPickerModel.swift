//
//  PhotoPickerModel.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/11.
//

import UIKit
import Photos
import MapKit

struct PhotoPickerModel: Identifiable {
    enum MediaType {
        case photo,
             video,
             livePhoto
    }
    let id: String
    let photo: UIImage?
    let url: URL?
    let livePhoto: PHLivePhoto?
    let mediaType: MediaType
    
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        self.url = nil
        self.livePhoto = nil
        mediaType = .photo
    }
    
    init(with videoURL: URL, photo: UIImage? = nil) {
        id = UUID().uuidString
        self.photo = photo
        url = videoURL
        self.livePhoto = nil
        mediaType = .video
    }
     
    init(with livePhoto: PHLivePhoto) {
        id = UUID().uuidString
        self.photo = nil
        self.url = nil
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
}
