//
//  UIApplilcation+safeArea.swift.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/04.
//

import UIKit

extension UIApplication {
    static func getSafeArea() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
