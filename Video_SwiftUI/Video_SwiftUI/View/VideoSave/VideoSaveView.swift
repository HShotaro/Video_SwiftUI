//
//  VideoSaveView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/07.
//

import SwiftUI

struct VideoSaveView: View {
    enum Stateful: Equatable {
        case editing
        case uploadError(Error)
        case uploaded
        static func == (lhs: VideoSaveView.Stateful, rhs: VideoSaveView.Stateful) -> Bool {
            switch (lhs, rhs) {
            case (.editing, .editing):
                return true
            case (.uploadError(let l), .uploadError(let r)):
                return l.localizedDescription == r.localizedDescription
            case (.uploaded, .uploaded):
                return true
            default:
                return false
            }
        }
    }
    @EnvironmentObject var videoSelectionEnvironmentObject: VideoSelectionEnvironmentObject
    @StateObject var viewModel = VideoSaveViewModel()
    @State var videoTitle: String = ""
    
    let url: URL
    var body: some View {
        Group {
            switch viewModel.state {
            case .editing:
                VStack {
                    HStack(spacing: 5) {
                        Text("タイトル名: ")
                        TextField("", text: $videoTitle)
                    }
                    Button {
                        self.viewModel.addVideo(videoTitle: videoTitle, urlString: url.absoluteString)
                    } label: {
                        Text("この内容で保存する")
                    }
                }.padding(.leading, 12.0)
            case .uploaded:
                Text("アップロードに成功しました")
            case let .uploadError(error):
                VStack {
                    Text(error.localizedDescription)
                    Button {
                        Task {
                            try await self.viewModel.addVideo(videoTitle: videoTitle, urlString: url.absoluteString)
                        }
                    } label: {
                        Text("\(error.localizedDescription)\nリトライ")
                    }
                }
            }
        }.onChange(of: viewModel.state, perform: { state in
            switch state {
            case .editing:
                break
            case .uploaded:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    videoSelectionEnvironmentObject.isPresented.wrappedValue = false
                }
            case .uploadError:
                break
            }
        })
    }
}

struct VideoSaveView_Previews: PreviewProvider {
    static var previews: some View {
        VideoSaveView(url: URL(string: "")!)
    }
}
