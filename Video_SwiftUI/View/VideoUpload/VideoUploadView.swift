//
//  VideoUploadView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/13.
//

import SwiftUI

struct VideoUploadView: View {
    enum Stateful: Equatable {
    case editing
    case uploadError(Error)
    case uploaded
        static func == (lhs: VideoUploadView.Stateful, rhs: VideoUploadView.Stateful) -> Bool {
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
    
    @StateObject var viewModel = VideoUploadViewModel()
    @State var videoTitle: String = ""
    @State var description: String = ""

    @EnvironmentObject var videoSelectionEnvironmentObject: VideoSelectionEnvironmentObject
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
                    HStack(spacing: 5) {
                        Text("紹介文: ")
                        TextField("", text: $description)
                    }
                                  
                    Button {
//                        Task {
//                            try await self.viewModel.upload(videoURL: url, videoTitle: videoTitle, description: description)
//                        }
                    } label: {
                        Text("アップロード")
                    }
                }.padding(.leading, 12.0)
                
            case .uploaded:
                Text("アップロードに成功しました")
            case let .uploadError(error):
                VStack {
                    Text(error.localizedDescription)
                    Button {
//                        Task {
//                            try await self.viewModel.upload(videoURL: url, videoTitle: videoTitle, description: description)
//                        }
                    } label: {
                        Text("リトライ")
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
        }).environmentObject(VideoSelectionEnvironmentObject.shared)
    }
}

struct VideoUploadView_Previews: PreviewProvider {
    static var previews: some View {
        VideoUploadView(url: URL(string: "")!)
    }
}
