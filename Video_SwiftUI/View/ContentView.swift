//
//  ContentView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct ContentView: View {
    enum Tab: String, CaseIterable {
            case home = "ホーム"
            case timeline = "タイムライン"
            case chat = "チャット"
            case myvideo = "マイビデオ"
        }
    @State private var selection: Tab = .home
    @State private var isVideoSelectionPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            switch selection {
            case .home:
                HomeView()
            case .timeline:
                TimelineView()
            case .chat:
                ChatView()
            case .myvideo:
                MyVideoView()
            }
            if isVideoSelectionPresented {
                Color.clear.fullScreenCover(isPresented: $isVideoSelectionPresented) {
                    NavigationView {
                        VideoSelectionView(isPresented: $isVideoSelectionPresented)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Divider()
                    BottomTabView(selection: $selection, isVideoFilingPresented: $isVideoSelectionPresented)
                        .frame(height: BottomTabView.height)
                }.ignoresSafeArea()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
