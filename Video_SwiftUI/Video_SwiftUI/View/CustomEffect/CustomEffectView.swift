//
//  TimelineView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI
import AVKit

struct CustomEffectView: View {
    @StateObject var viewModel = CustomEffectViewModel()
    @State var destinationView: AnyView? = nil
    @State var isPushActive = false
    
    private var avPlayer: AVPlayer? {
        guard let videoURL = viewModel.videoURL else { return nil }
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = viewModel.videoComposition
        return AVPlayer(playerItem: playerItem)
    }
    
    var body: some View {
        NavigationView {
            Group {
                NavigationLink(isActive: $isPushActive) {
                    destinationView
                } label: {
                    EmptyView()
                }
                ZStack {
                    VideoPlayer(player: avPlayer)
                    VSFloatingButtonView(tappedHandler: addButtonTapped)
                }
            }.padding(.bottom, BottomTabView.height)
                .navigationTitle(ContentView.Tab.customEffect.rawValue)
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.viewModel.isPHPhotoPickerViewPresented = true
                }, label: {
                    Image(systemName: "photo")
                        .foregroundColor(Color.dominantColor)
                })
                ).sheet(isPresented: $viewModel.isPHPhotoPickerViewPresented, content: {
                    VSPHPickerViewController { results in
                        if let result = results.first {
                            viewModel.getPHPickerResult(result)
                        }
                    }
                })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func addButtonTapped() {
        guard let url = viewModel.videoURL else { return }
        self.destinationView = AnyView(MetalVideoView(url: url))
        self.isPushActive = true
    }
}

struct CustomEffectView_Previews: PreviewProvider {
    static var previews: some View {
        CustomEffectView()
    }
}
