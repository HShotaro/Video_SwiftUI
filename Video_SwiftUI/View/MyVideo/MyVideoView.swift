//
//  MypageView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI
import AVKit

struct MyVideoView: View {
    @StateObject var viewModel = MyVideoViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.videoURLs, id: \.self.absoluteString) { videoURL in
                HStack(spacing: 5) {
                    if viewModel.onEditing {
                        Button(action: {
                            self.viewModel.toggleSelectedVideoState(selectedVideo: videoURL)
                        }) {
                            if viewModel.selectedVideos.contains(videoURL) {
                                Image(systemName: "checkmark.circle.fill")
                            } else {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        .foregroundColor(Color.accentColor)
                        .frame(width: 60, height: 60, alignment: .center)
                        .buttonStyle(PlainButtonStyle())
                    }
                    VideoPlayer(player: AVPlayer(url: videoURL))
                        .frame(minHeight: 200)
                }
            }
            .padding(.bottom, BottomTabView.height)
            .navigationTitle(ContentView.Tab.myvideo.rawValue)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.viewModel.deleteVideos()
                    }) {
                        Text("\(viewModel.selectedVideos.count)件削除")
                    }.disabled(!viewModel.onEditing)
                    .opacity(viewModel.onEditing ? 1.0 : 0.0)
            , trailing:
                    Button(action: {
                        self.viewModel.onEditing.toggle()
                    }) {
                        Text(viewModel.onEditing ? "キャンセル" : "編集")
                    }
            )
            .onAppear {
                viewModel.refreshVideoURLs()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MyVideoView_Previews: PreviewProvider {
    static var previews: some View {
        MyVideoView()
    }
}
