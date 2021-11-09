//
//  Color+definition.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI

extension Color {
    static let dominantColor: Color = Color(dominantUIColor)
    static let dominantUIColor: UIColor = UIColor.systemPink
    
    static let accentColor: Color = Color(accentUIColor)
    static let accentUIColor: UIColor = UIColor.systemRed
}
