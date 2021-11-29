//
//  UIImage+load.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/15.
//

import UIKit
import SDWebImage

func downloadImageAsync(url: URL, completion: @escaping (UIImage?) -> Void) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { (data, _, _) in
        var image: UIImage?
        if let imageData = data {
            image = UIImage(data: imageData)
        }
        DispatchQueue.main.async {
            completion(image)
        }
    }
    task.resume()
}
