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
    
    
    @State var url: URL
    let sourceType: VideoSelectionView.DisplayMode
    
    var body: some View {
        NavigationLink(destination: destinationView, isActive: $isPushActive) {
            EmptyView()
        }
        VideoEditingViewRepresentable(currentVideoAssetStartPoint: $currentVideoAssetStartPoint, currentVideoAssetEndPoint: $currentVideoAssetEndPoint, isPushActive: $isPushActive, url: url)
            .navigationBarItems(trailing: Button("次へ", action: {
                let asset = AVURLAsset(url: url)
                let currentVideoAssetEndpoint: Double = currentVideoAssetEndPoint ?? asset.duration.seconds
                guard let newComposition = VideoEditingView.getNewComposition(asset: asset, startTime: currentVideoAssetStartPoint, endTime: currentVideoAssetEndpoint) else { return }
                Task {
                    do {
                        let newUrl = try await newComposition.write()
                        if sourceType == .filming {
                            try await url.delete()
                        }
                        DispatchQueue.main.async {
                            self.url = newUrl
                            self.destinationView = AnyView(VideoFilterView(url: url))
                            self.isPushActive = true
                        }
                    } catch {
                        
                    }
                }
            }))
    }
    
    static func getNewComposition(asset: AVURLAsset, startTime: Double, endTime: Double) -> AVComposition? {
        let composition = AVMutableComposition()
        guard let videoCompositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else { return nil }
        guard let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else { return nil }
        guard let videoAssetTrack = asset.tracks(withMediaType: .video).first else { return nil }
        guard let audioAssetTrack = asset.tracks(withMediaType: .audio).first else { return nil }
        do {
            try videoCompositionTrack.insertTimeRange(CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: videoAssetTrack.naturalTimeScale), end: CMTime(seconds: endTime, preferredTimescale: videoAssetTrack.naturalTimeScale)), of: videoAssetTrack, at: .zero)
            try audioCompositionTrack.insertTimeRange(CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: audioAssetTrack.naturalTimeScale), end: CMTime(seconds: endTime, preferredTimescale: audioAssetTrack.naturalTimeScale)), of: audioAssetTrack, at: .zero)
            return composition.copy() as? AVComposition
        } catch {
            return nil
        }
    }
}

struct VideoEditingView_Previews: PreviewProvider {
    static var previews: some View {
        VideoEditingView(url: URL(string: "")!, sourceType: .library)
    }
}
