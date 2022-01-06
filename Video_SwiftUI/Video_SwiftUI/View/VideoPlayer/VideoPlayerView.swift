//
//  VideoPlayerView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/13.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let url: URL
    var body: some View {
        VideoPlayer(player: AVPlayer(playerItem: AVPlayerItem(url: url)))
            .frame(minWidth: 220)
            
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(url: URL(string: "")!)
    }
}
