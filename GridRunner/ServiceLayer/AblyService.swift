//
//  Ably.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 14.06.23.
//

import Ably

class AblyService {
    private var client: ARTRealtime
    private var channel: ARTRealtimeChannel
    
    static let shared = AblyService()
    
    private init() {
        self.client = ARTRealtime(token: "token")
        self.channel = client.channels.get("channelName")
    }
    
    func update(with token: String, and channelName: String) {
        self.client = ARTRealtime(token: token)
        self.channel = client.channels.get(channelName)
    }
    
    func enterQueue() {
        client.connection.on(.connected) { stateChange in
            NSLog("Connected to Ably.")
            self.enter()
        }
    }
    
    func leaveQueue() {
        self.leave()
    }
    
    func startGame() {
        self.leaveQueue()
        self.client.connect()
        client.connection.on(.connected) { stateChange in
            NSLog("Connected to Ably.")
            self.game()
        }
    }
    
    private func enter() {
        NSLog("Entering channel \"\(self.channel.name)\" queue.")
    
        self.channel.subscribe("game") { message in
            if let data = message.data as? [String: Any] {
                // check if ids are same
               if let payload = GameSessionDetails.decode(data: data) {
                   if payload.runner == User.shared.username || payload.seeker == User.shared.username {
                       GameSessionDetails.shared.update(with: payload)
                       DispatchQueue.main.async {
                           NotificationCenter.default.post(name: NSNotification.Name("Success::Matchmaking"), object: nil)
                       }
                   }
               }
           }
        }
        
        self.channel.presence.enter(nil)
    }
    
    private func leave() {
        NSLog("Leaving channel \"\(self.channel.name)\" queue.")
        self.channel.unsubscribe()
        self.channel.presence.leave(nil)
    }
    
    private func game() {
        let channelName = "room:\(GameSessionDetails.shared.roomCode):\(User.shared.username)"
        let channel = self.client.channels.get(channelName)
        
        NSLog("Entering channel \"\(channelName)\".")
        
        channel.subscribe(GameSessionDetails.shared.roomCode) { message in
            print(String(describing: message.data))
        }
        
        channel.presence.enter(nil)
    }
}
