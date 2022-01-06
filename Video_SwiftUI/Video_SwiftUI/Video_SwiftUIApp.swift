//
//  Video_SwiftUIApp.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/06.
//

import SwiftUI

@main
struct Video_SwiftUIApp: App {
    @EnvironmentObject var videoSelectionEnvironmentObject: VideoSelectionEnvironmentObject
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(VideoSelectionEnvironmentObject.shared)
        }
    }
}
