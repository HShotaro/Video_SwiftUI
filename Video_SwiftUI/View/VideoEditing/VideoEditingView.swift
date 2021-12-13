//
//  VideoEditingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/11.
//

import SwiftUI
import AVFoundation

struct VideoEditingView: View {
    @State var currentVideoAssetStartPoint: Double = 0.0
    @State var currentVideoAssetEndPoint: Double?
    @State var isPushActive = false
    @State var destinationView: AnyView? = nil
    
    struct FileExportError: Error {}
    struct AVAssetExportSessionError: Error {}
    
    let url: URL
    var body: some View {
        NavigationLink(destination: destinationView, isActive: $isPushActive) {
            EmptyView()
        }
        VideoEditingViewRepresentable(currentVideoAssetStartPoint: $currentVideoAssetStartPoint, currentVideoAssetEndPoint: $currentVideoAssetEndPoint, isPushActive: $isPushActive, url: url)
            .navigationBarItems(trailing: Button("次へ", action: {
                let asset = AVURLAsset(url: url)
                let currentVideoAssetEndpoint: Double = currentVideoAssetEndPoint ?? asset.duration.seconds
                guard let newComposition = VideoEditingView.getNewComposition(asset: asset, startTime: currentVideoAssetStartPoint, endTime: currentVideoAssetEndpoint) else { return }
                
                VideoEditingView.write(composition: newComposition) { result in
                    switch result {
                    case let .success(url):
                        self.destinationView = AnyView(VideoUploadView(url: url))
                        self.isPushActive = true
                    case .failure:
                        break
                    }
                }
            }))
    }
    
    static func getNewComposition(asset: AVURLAsset, startTime: Double, endTime: Double) -> AVComposition? {
        let composition = AVMutableComposition()
        guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else { return nil }
        guard let track = asset.tracks(withMediaType: .video).first else { return nil }
        do {
            try videoTrack.insertTimeRange(CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: track.naturalTimeScale), end: CMTime(seconds: endTime, preferredTimescale: track.naturalTimeScale)), of: track, at: .zero)
            return composition.copy() as? AVComposition
        } catch {
            return nil
        }
    }
    
    static func write(composition: AVComposition, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let session = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough) else {
            completion(.failure(AVAssetExportSessionError()))
            return
        }
        session.outputURL = URL.temporaryExportURL()
        session.outputFileType = .mp4
        session.exportAsynchronously {
            switch session.status {
            case .completed:
                if let url = session.outputURL {
                    completion(.success(url))
                } else {
                    completion(.failure(FileExportError()))
                }
            case .failed:
                completion(.failure(session.error ?? FileExportError()))
            default:
                break
            }
        }
    }
}

struct VideoEditingView_Previews: PreviewProvider {
    static var previews: some View {
        VideoEditingView(url: URL(string: "")!)
    }
}
