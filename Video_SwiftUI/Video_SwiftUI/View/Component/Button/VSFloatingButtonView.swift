//
//  VSFloatingButton.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/31.
//

import SwiftUI

struct VSFloatingButtonView: View {
    var tappedHandler: (() -> Void)? = nil
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    tappedHandler?()
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                })
                    .frame(width: 60, height: 60)
                    .background(Color.dominantColor)
                    .cornerRadius(30.0)
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))
            }
        }
    }
}

struct VSFloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VSFloatingButtonView()
    }
}
