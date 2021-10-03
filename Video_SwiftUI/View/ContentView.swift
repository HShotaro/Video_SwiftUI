//
//  ContentView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
            case home
            case timeline
            case videoFilming
            case messageList
            case mypage
        }
    @State private var selection: Tab = .home
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label(
                        title: { Text("ホーム") },
                        icon: { Image(systemName: "house")
                        }
                    )
                }.tag(Tab.home)
            
            TimelineView()
                .tabItem {
                    Label(
                        title: { Text("タイムライン") },
                        icon: { Image(systemName: "clock")
                        }
                    )
                }.tag(Tab.timeline)
            
            VideoFilmingView()
                .tabItem {
                    Image(uiImage: UIImage.videoFilming).resizable()
                }.tag(Tab.videoFilming)
            
            MessageListView()
                .tabItem {
                    Label(
                        title: { Text("メッセージ") },
                        icon: { Image(systemName: "text.bubble")
                        }
                    )
                }.tag(Tab.messageList)
            
            MypageView()
                .tabItem {
                    Label(
                        title: { Text("マイページ") },
                        icon: { Image(systemName: "person")
                        }
                    )
                }.tag(Tab.mypage)
        }.accentColor(Color.primaryColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
