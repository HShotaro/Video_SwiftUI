//
//  url+export.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/13.
//

import Foundation

extension URL {
    static func exportURL() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let filename = ProcessInfo.processInfo.globallyUniqueString + ".mp4"
        return documentDirectory.appendingPathComponent(filename)
    }
}
