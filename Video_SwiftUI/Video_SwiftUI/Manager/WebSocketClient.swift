//
//  WebSocketClient.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/20.
//

import Foundation
import MapKit

fileprivate let pubSession = URLSession(configuration: URLSessionConfiguration.default)
fileprivate let websocketURL = URL(string: "")!
class WebSocketClient {
    static let shared = WebSocketClient()
    
    var applyPriceChanges: ([MenuItem]) -> Void = { _ in  }
    var webSocketTask: URLSessionWebSocketTask?
    
    private init() {}
    
    func connect() {
        let task = pubSession.webSocketTask(with: websocketURL)
        self.webSocketTask = task
        
        task.resume()
        readMessage()
    }
    
    func readMessage() {
        guard let task = self.webSocketTask else { return }
        task.receive { result in
            switch result {
            case .success(.data(let data)):
                if let priceChanges = try? JSONDecoder().decode([MenuItem].self, from: data) {
                    self.applyPriceChanges(priceChanges)
                }
                self.readMessage()
            case .success(.string(_)):
                break
            case .success(_):
                break
            case .failure:
                self.disConnect()
            }
        }
    }
    
    func disConnect() {
        webSocketTask?.cancel()
        webSocketTask = nil
    }
    
    func sendPing(handler: @escaping (TimeInterval?) -> Void) {
        if let task = webSocketTask {
            let sendDate = Date()
            task.sendPing { error in
                
            }
        }
    }
}
