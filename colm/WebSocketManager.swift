//
//  WebSocketManager.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 23/04/2023.
//

import Foundation

class WebSocketManager: ObservableObject {
    static let wsUrl = ProcessInfo.processInfo.environment["base_server_ws_url"]!
    var task: URLSessionWebSocketTask!
    var callBack: () -> Void
    
    init(uri: String) {
        let url = URL(string: WebSocketManager.wsUrl + uri)!
        task = URLSession.shared.webSocketTask(with: url)
        task.resume()
        self.callBack = {}
        self.receiveMessages()
    }
    
    deinit {
        task.cancel()
    }
    
    func receiveMessages() {
        task.receive { result in
            switch result {
            case .success:
                self.callBack()
                self.receiveMessages()
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
    }
    
    func setCallBack(_ completionHandler: @escaping () -> Void) {
        self.callBack = completionHandler
    }
}
