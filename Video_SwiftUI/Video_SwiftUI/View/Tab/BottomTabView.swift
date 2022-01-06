//
//  BottomTabView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/03.
//

import SwiftUI

struct BottomTabView: View {
    static let height: CGFloat = 60
    @Binding var selection: ContentView.Tab
    @Binding var isVideoFilingPresented: Bool
    @EnvironmentObject var videoSelectionEnvironmentObject: VideoSelectionEnvironmentObject
    var body: some View {
        HStack(spacing: 0) {
            Button {
                isVideoFilingPresented = false
                selection = .home
            } label: {
                VStack {
                    BottomTabItemView(image: Image(systemName: "house"), text: ContentView.Tab.home.rawValue, tab: .home, selected: $selection
                    ).frame(width: itemWidth())
                }
            }
            
            Button {
                isVideoFilingPresented = false
                selection = .timeline
            } label: {
                VStack {
                    BottomTabItemView(image: Image(systemName: "clock"), text: ContentView.Tab.timeline.rawValue, tab: .timeline, selected: $selection
                    ).frame(width: itemWidth())
                }
            }
            
            Button {
                isVideoFilingPresented = true
                videoSelectionEnvironmentObject.isPresented = $isVideoFilingPresented
            } label: {
                VStack {
                    Image(uiImage: UIImage.videoFilming)
                        .resizable()
                        .frame(width: 60, height: 44)
                }.frame(width: itemWidth())
            }
            
            Button {
                isVideoFilingPresented = false
                selection = .chat
            } label: {
                VStack {
                    BottomTabItemView(image: Image(systemName: "text.bubble"), text: ContentView.Tab.chat.rawValue, tab: .chat, selected: $selection
                    ).frame(width: itemWidth())
                }
            }
            
            Button {
                isVideoFilingPresented = false
                selection = .myvideo
            } label: {
                VStack {
                    BottomTabItemView(image: Image(systemName: "person"), text:ContentView.Tab.myvideo.rawValue, tab: .myvideo, selected: $selection
                    ).frame(width: itemWidth())
             
                }
            }
        }.padding(.bottom, UIApplication.getSafeArea().bottom == 0 ? 0 : UIApplication.getSafeArea().bottom)
    }
    
    private func itemWidth() -> CGFloat {
        let pageWidth: CGFloat = UIScreen.main.bounds.width - UIApplication.getSafeArea().left - UIApplication.getSafeArea().right
        return pageWidth / CGFloat(ContentView.Tab.allCases.count + 1)
    }
}

struct BottomTabView_Previews: PreviewProvider {
    @State static var selection: ContentView.Tab = .home
    @State static var isVideoFilingPresented = false
    static var previews: some View {
        BottomTabView(selection: BottomTabView_Previews.$selection, isVideoFilingPresented: BottomTabView_Previews.$isVideoFilingPresented)
    }
}
