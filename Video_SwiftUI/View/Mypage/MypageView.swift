//
//  MypageView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

struct MypageView: View {
    var body: some View {
        NavigationView {
            Text("Mypage")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MypageView_Previews: PreviewProvider {
    static var previews: some View {
        MypageView()
    }
}
