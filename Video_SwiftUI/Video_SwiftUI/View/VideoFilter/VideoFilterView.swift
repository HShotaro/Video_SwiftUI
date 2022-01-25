//
//  VideoFilterView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/21.
//

import SwiftUI
import AVKit

struct VideoFilterView: View {
    @StateObject var viewModel = VideoFilterViewModel()
    @State var destinationView: AnyView? = nil
    @State var isPushActive = false
    
    let url: URL
    
    private let thumbnailSize: CGSize = {
        return CGSize(width: 120, height: 120)
    }()
    
    enum FilterType: String, CaseIterable {
        case none = ""
        case colorClamp = "CIColorClamp"
        case sepiaTone = "CISepiaTone"
        case gaussianBlur = "CIGaussianBlur"
        case vignetteEffect = "CIVignetteEffect"
        case toneCurve = "CIToneCurve"
        
        
        func toName() -> String {
            switch self {
            case .none: return "なし"
            case .colorClamp: return "カラークランプ"
            case .sepiaTone: return "セピアトーン"
            case .gaussianBlur: return "ぼかし"
            case .vignetteEffect: return "ヴィネットエフェクト"
            case .toneCurve: return "トーンカーブ"
            }
        }
    }
    
    private var avPlayer: AVPlayer {
        guard let videoComposition = viewModel.videoComposition else { return AVPlayer(playerItem: AVPlayerItem(url: url)) }
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = videoComposition
        return AVPlayer(playerItem: playerItem)
    }
    
    var body: some View {
        VStack {
            if let currentProgress = viewModel.currentProgress {
                ProgressView("Downloading...", value: currentProgress, total: 1.0)
                    .accentColor(Color.accentColor)
                    .foregroundColor(Color.dominantColor)
            } else {
                NavigationLink(isActive: $isPushActive) {
                    destinationView
                } label: {
                    EmptyView()
                }
                Spacer()
                VideoPlayer(player: avPlayer)
                    .frame(height: 350)
                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: Array(repeating: GridItem(), count: 1), spacing: 5) {
                        ForEach((0..<viewModel.thumbnails.count), id: \.self) { index in
                            Button {
                                viewModel.selectFilter(url: url, type: FilterType.allCases[index])
                            } label: {
                                VStack {
                                    Text(FilterType.allCases[index].toName())
                                        .font(.system(size: 30, weight: .bold, design: .default))
                                        .minimumScaleFactor(0.4)
                                    Image(uiImage: viewModel.thumbnails[index])
                                        .resizable()
                                        .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                                }.padding(.horizontal, 4)
                                    .padding(.top, 4)
                                    .border(FilterType.allCases[index] == viewModel.filterType ? Color.accentColor : Color.gray, width: 3)
                            }.frame(width: thumbnailSize.width + 8)

                            
                        }
                    }
                    .frame(height: 144)
                        .padding(.top, 12)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 20)
                }
            }
        }.navigationBarItems(trailing:
            Button("次へ", action: {
            Task {
                viewModel.startShowingProgressView()
                let result = await viewModel.writeFilteredVideo(url: url)
                viewModel.stopShowingProgressView()
                switch result {
                case let .success(newURL):
                    DispatchQueue.main.async {
                        destinationView = AnyView(VideoSaveView(url: newURL ?? url))
                        isPushActive = true
                    }
                case .failure:
                    break
                }
            }
        }).disabled(viewModel.currentProgress != nil)
        )
        .onAppear {
            Task {
                await viewModel.createThumbnails(url: url, thumbnailSize: thumbnailSize, screenScale: UIScreen.main.scale)
            }
        }.onDisappear {
            viewModel.stopShowingProgressView()
        }
    }
}

struct VideoFilterView_Previews: PreviewProvider {
    static var previews: some View {
        VideoFilterView(url: URL(string: "")!)
    }
}
