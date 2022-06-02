//
//  MessageListView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI
import SceneKit

struct _360DegreeView: View {
    let scene = _360DegreeScene()
    var body: some View {
        NavigationView {
            SceneView(scene: scene)
                .gesture(DragGesture().onChanged(scene.drag(value:)))
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
