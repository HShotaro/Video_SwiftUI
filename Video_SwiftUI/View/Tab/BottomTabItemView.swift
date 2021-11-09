//
//  BottomTabItemView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/04.
//

import SwiftUI

struct BottomTabItemView: View {
    let image: Image
    let text: String
    let tab: ContentView.Tab
    @Binding var selected: ContentView.Tab
    var body: some View {
        VStack {
            image
                .font(.system(size: 20))
                .foregroundColor(selected == tab ? Color.dominantColor: Color.gray)
            Text(text)
                .font(.system(size: 9))
                .foregroundColor(selected == tab ? Color.dominantColor: Color.gray)
        }
    }
    
    
}

struct BottomTabItemView_Previews: PreviewProvider {
    @State static var selected: ContentView.Tab = .home
    static var previews: some View {
        BottomTabItemView(image: Image(systemName: "house"), text: "ホーム", tab: .home, selected: BottomTabItemView_Previews.$selected)
    }
}
