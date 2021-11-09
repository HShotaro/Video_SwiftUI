//
//  Mock.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/10.
//

import Foundation

let mocks = [Int](0...20).map { Mock(id: $0) }
struct Mock {
    let id: Int
    let mainText: String
    let subText: String
    let placeholder: URL?
    
    init(id: Int) {
        self.id = id
        mainText = "mainText\(id)"
        subText = "subText\(id)"
        placeholder = URL(string: "https://via.placeholder.com/200x200?text=\(id)")
    }
}
