//
//  MessageListView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            Text("Message List")
                .padding(.bottom, BottomTabView.height)
                .navigationTitle(ContentView.Tab.chat.rawValue)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
