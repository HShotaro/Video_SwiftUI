//
//  Video_SwiftUIApp.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/10/03.
//

import SwiftUI
import RxSwift
import Firebase

@main
struct Video_SwiftUIApp: App {
    @EnvironmentObject var videoSelectionEnvironmentObject: VideoSelectionEnvironmentObject
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(VideoSelectionEnvironmentObject.shared)
        }
    }
}
