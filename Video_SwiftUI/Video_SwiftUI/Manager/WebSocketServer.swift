//
//  WebSocketServer.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/20.
//

import Foundation
import Network

class WebSocketServer {
    static let shared = WebSocketServer()
    
    let listener: NWListener
    var connectedClients = [NWConnection]()
    
    private init() {
        let tlsOptions = NWProtocolTLS.Options()
        configureLocalIdentity(on: tlsOptions)
        let parameters = NWParameters(tls: tlsOptions)
        let wsOptions = NWProtocolWebSocket.Options()
        wsOptions.autoReplyPing = true
        parameters.defaultProtocolStack.applicationProtocols.insert(wsOptions, at: 0)
        
        do {
            listener = try NWListener(using: parameters, on: 8000)
            let serverQueue = DispatchQueue(label: "serverQueue")
            listener.newConnectionHandler = { newConnection in
                self.connectedClients.append(newConnection)
                newConnection.start(queue: serverQueue)
                
                func receive() {
                    newConnection.receiveMessage { data, context, isComplete, error in
                        if let data = data, let context = context {
                            self.handleMessage(data: data, context: context)
                            receive()
                        }
                    }
                }
                receive()
            }
            listener.start(queue: serverQueue)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func sendPriceChanges(items: [MenuItem]) throws {
        let data = try JSONEncoder().encode(items)
        
        for client in connectedClients {
            let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
            let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
            
            client.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed({ error in
                
            }))
        }
    }
    
    private func handleMessage(data: Data, context: Network.NWConnection.ContentContext) {
        
    }
}

fileprivate func configureLocalIdentity(on: NWProtocolTLS.Options) {
    
}

struct MenuItem: Codable {
    
}
