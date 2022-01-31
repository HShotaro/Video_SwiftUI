//
//  MetalVideoView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/31.
//

import SwiftUI

struct MetalVideoView: View {
    let url: URL
    var body: some View {
        Text(url.absoluteString)
    }
}

struct MetalVideoView_Previews: PreviewProvider {
    static var previews: some View {
        MetalVideoView(url: URL(string: "")!)
    }
}
