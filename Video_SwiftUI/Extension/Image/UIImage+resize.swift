//
//  UIImage+resize.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import UIKit
import AVFoundation

extension UIImage {
    static let facetime: UIImage = UIImage(named: "facetime") ?? UIImage()
    
    
    static let videoFilming: UIImage = {
        let v = UIImage.facetime.resizeImage(targetRect: CGRect(x: 0, y: 0, width: 60, height: 44)) ?? UIImage()
        return v
    }()
    
    func resizeImage(targetRect: CGRect) -> UIImage? {
        let widthRatio  = targetRect.width  / size.width
        let heightRatio = targetRect.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: targetRect.origin, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
