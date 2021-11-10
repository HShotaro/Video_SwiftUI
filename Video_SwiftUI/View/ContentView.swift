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
            case messageList = "メッセージ"
            case mypage = "マイページ"
        }
    @State private var selection: Tab = .home
    @State private var isVideoFilingPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            switch selection {
            case .home:
                NavigationView {
                    HomeView()
                        .padding(.bottom, BottomTabView.height)
                        .navigationTitle(ContentView.Tab.home.rawValue)
                }
            case .timeline:
                NavigationView {
                    TimelineView()
                        .padding(.bottom, BottomTabView.height)
                        .navigationTitle(ContentView.Tab.timeline.rawValue)
                }
            case .messageList:
                NavigationView {
                    MessageListView()
                        .padding(.bottom, BottomTabView.height)
                        .navigationTitle(ContentView.Tab.messageList.rawValue)
                }
            case .mypage:
                NavigationView {
                    MypageView()
                        .padding(.bottom, BottomTabView.height)
                        .navigationTitle(ContentView.Tab.mypage.rawValue)
                }
            }
            if isVideoFilingPresented {
                EmptyView().fullScreenCover(isPresented: $isVideoFilingPresented) {
                    NavigationView {
                        VideoSelectionView(isPresented: $isVideoFilingPresented)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Divider()
                    BottomTabView(selection: $selection, isVideoFilingPresented: $isVideoFilingPresented)
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