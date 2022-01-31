//
//  ImageView.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/15.
//

import SwiftUI

struct VSImageView: View {
    @State var image: UIImage = UIImage(systemName: "photo") ?? UIImage()
    let imageURL: URL?
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .padding(.all, 0.0)
            .aspectRatio(1, contentMode: .fit)
            .onAppear {
                DispatchQueue.global().async {
                    if let url = imageURL {
                        downloadImageAsync(url: url) { image in
                            self.image = image ?? UIImage()
                        }
                    }
                }
            }
    }
}

struct VSImageView_Previews: PreviewProvider {
    static var previews: some View {
        VSImageView(imageURL: URL(string: "https://via.placeholder.com/150/0000FF/808080")!)
    }
}
