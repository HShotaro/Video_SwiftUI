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
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Video.addedDate, ascending: true)],
        animation: .default)
    private var videos: FetchedResults<Video> {
        didSet {
            viewModel.onEditing = false
        }
    }
    
    var body: some View {
        NavigationView {
            List(videos, id: \.self.objectID) { v in
                VStack(spacing: 5) {
                    if let title = v.title {
                        Text(title)
                    }
                    HStack(spacing: 5) {
                        if viewModel.onEditing {
                            Button(action: {
                                self.viewModel.toggleSelectedVideoState(selectedVideo: v)
                            }) {
                                if viewModel.selectedVideos.contains(v) {
                                    Image(systemName: "checkmark.circle.fill")
                                } else {
                                    Image(systemName: "checkmark.circle")
                                }
                            }
                            .foregroundColor(Color.accentColor)
                            .frame(width: 60, height: 60, alignment: .center)
                            .buttonStyle(PlainButtonStyle())
                        }
                        if let url = URL(string: v.urlString ?? "") {
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(minHeight: 200)
                        }
                    }
                    if let addedDate = v.addedDate {
                        Text(addedDate, formatter: itemFormatter)
                    }
                }
            }
            .padding(.bottom, BottomTabView.height)
            .navigationTitle(ContentView.Tab.myvideo.rawValue)
            .navigationBarItems(
                leading:
                    Button(action: {
                        Task {
                            try await self.viewModel.deleteVideos()
                        }
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct MyVideoView_Previews: PreviewProvider {
    static var previews: some View {
        MyVideoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
