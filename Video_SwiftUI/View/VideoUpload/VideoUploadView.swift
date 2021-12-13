//
//  VideoUploadView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/13.
//

import SwiftUI

struct VideoUploadView: View {
    @StateObject var viewModel = VideoUploadViewModel()
    @EnvironmentObject var videoSelectionEnvironmentObject: VideoSelectionEnvironmentObject
    let url: URL
    
    
    var body: some View {
        Button {
            videoSelectionEnvironmentObject.isPresented.wrappedValue = false
        } label: {
            Text("最初の画面に戻る")
        }.environmentObject(VideoSelectionEnvironmentObject.shared)

    }
}

struct VideoUploadView_Previews: PreviewProvider {
    static var previews: some View {
        VideoUploadView(url: URL(string: "")!)
    }
}
