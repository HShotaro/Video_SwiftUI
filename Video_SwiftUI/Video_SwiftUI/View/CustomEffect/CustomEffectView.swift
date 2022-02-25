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
    
    private var customEffectViewRepresentable: VSCustomEffectViewRepresentable? {
        guard let videoURL = viewModel.videoURL else { return nil }
        let asset = AVURLAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = viewModel.videoComposition
        let viewRepresentable = VSCustomEffectViewRepresentable(playerItem: playerItem)
        return viewRepresentable
    }
    
    var body: some View {
        NavigationView {
            customEffectViewRepresentable
                .padding(.bottom, BottomTabView.height)
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
}

struct CustomEffectView_Previews: PreviewProvider {
    static var previews: some View {
        CustomEffectView()
    }
}
