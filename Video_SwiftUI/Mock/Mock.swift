//
//  Mock.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/10.
//

import Foundation

let mocks = [Int](1...30).map { Mock(id: $0) }
struct Mock {
    let id: Int
    let mainText:String
    let subText: String
    let thumbnailURL: URL?
    init(id: Int) {
        self.id = id
        mainText = "mainText\(id)"
        subText = "subText\(id)"
        thumbnailURL = URL(string: "https://via.placeholder.com/200x200.png?text=\(id)")
    }
}
