//
//  MessageListView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct _360DegreeView: View {
    var body: some View {
        NavigationView {
            Text("Message List")
                .padding(.bottom, BottomTabView.height)
                .navigationTitle(ContentView.Tab._360Degree.rawValue)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct _360DegreeView_Previews: PreviewProvider {
    static var previews: some View {
        _360DegreeView()
    }
}
