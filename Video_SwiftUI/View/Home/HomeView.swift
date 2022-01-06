//
//  HomeView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("Home")
            .padding(.bottom, BottomTabView.height)
            .navigationTitle(ContentView.Tab.home.rawValue)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
