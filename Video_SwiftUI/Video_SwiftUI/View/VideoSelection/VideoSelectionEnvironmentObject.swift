//
//  VideoSelectionEnvironmentObject.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/13.
//

import SwiftUI

class VideoSelectionEnvironmentObject: ObservableObject {
    static let shared = VideoSelectionEnvironmentObject()
    private init() {}
    @Published var isPresented: Binding<Bool> = Binding<Bool>.constant(false)
}
