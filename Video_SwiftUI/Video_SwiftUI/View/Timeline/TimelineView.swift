//
//  TimelineView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct TimelineView: View {
    var body: some View {
        NavigationView {
            Text("Timeline")
                .padding(.bottom, BottomTabView.height)
                .navigationTitle(ContentView.Tab.timeline.rawValue)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
