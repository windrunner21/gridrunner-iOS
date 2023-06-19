//
//  Ably.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 14.06.23.
//

import Ably

class AblyService {
    private var client: ARTRealtime
    private var queueChannel: ARTRealtimeChannel
    private var gameChannel: ARTRealtimeChannel
    
    static let shared = AblyService()
    
    private init() {
        self.client = ARTRealtime(token: "token")
        self.queueChannel = client.channels.get("queuechannelName")
        self.gameChannel = client.channels.get("gameChannelName")
    }
    
    func update(with token: String, and queue: String) {
        self.client = ARTRealtime(token: token)
        self.queueChannel = client.channels.get(queue)
    }
    
    // Public methods for rest of the project to interact with: enter, leave queues and start game.
    func enterQueue() {
        client.connection.on(.connected) { stateChange in
            NSLog("Connected to Ably.")
            self._enter()
        }
    }
    
    func leaveQueue() {
        self._leave()
    }
    
    func enterGame() {
        self.leaveQueue()
        
        if client.connection.state == .connected {
            self._enterGame()
        } else {
            NSLog("Could not enter game")
        }
    }
    
    func leaveGame() {
        self._leaveGame()
    }
    
    private func _enter() {
        NSLog("Entering channel \"\(self.queueChannel.name)\" queue.")
    
        self.queueChannel.subscribe("game") { message in
            if let data = message.data as? [String: Any] {
                // Make sure that ids and username are the same to match correct accounts.
               if let payload = GameSessionDetails.toJSONAndDecode(data: data, type: GameSessionDetails.self) {
                   if payload.runner == User.shared.username || payload.seeker == User.shared.username {
                       GameSessionDetails.shared.update(with: payload)
                       DispatchQueue.main.async {
                           NotificationCenter.default.post(name: NSNotification.Name("Success::Matchmaking"), object: nil)
                       }
                   }
               }
           }
        }
        
        self.queueChannel.presence.enter(nil)
    }
    
    private func _leave() {
        NSLog("Leaving channel \"\(self.queueChannel.name)\" queue.")
        self.queueChannel.unsubscribe()
        self.queueChannel.presence.leave(nil)
    }
    
    private func _enterGame() {
        let channelName = "room:\(GameSessionDetails.shared.roomCode):\(User.shared.username)"
        self.gameChannel = self.client.channels.get(channelName)
        
        NSLog("Entering channel \"\(channelName)\".")
        
        self.gameChannel.subscribe(GameSessionDetails.shared.roomCode) { message in
            print(String(describing: message.data))
            if let data = message.data as? [String: Any] {
                if let payload = GameConfig.toJSONAndDecode(data: data, type: GameConfig.self) {
                    GameConfig.shared.update(with: payload)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("Success:GameConfig"), object: nil)
                    }
                }
            }
            
        }
        
        self.gameChannel.presence.enter(nil)
    }
    
    private func _leaveGame() {
        NSLog("Leaving channel \"\(self.gameChannel.name)\".")
        self.gameChannel.unsubscribe()
        self.gameChannel.presence.leave(nil)
    }
}
