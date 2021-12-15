//
//  NSMutableData+string.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/12/15.
//

import Foundation

extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
