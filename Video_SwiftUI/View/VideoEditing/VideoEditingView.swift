//
//  VideoEditingView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/11.
//

import SwiftUI
import AVKit

struct VideoEditingView: View {
    let url: URL
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .frame(minHeight: 220)
    }
}

struct VideoEditingView_Previews: PreviewProvider {
    static var previews: some View {
        VideoEditingView(url: URL(string: "")!)
    }
}
