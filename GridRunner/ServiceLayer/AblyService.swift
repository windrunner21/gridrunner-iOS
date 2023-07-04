//
//  Ably.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 14.06.23.
//

import Ably

class AblyService {
    private var client: ARTRealtime
    private var options: ARTClientOptions
    private var queueChannel: ARTRealtimeChannel
    private var gameChannel: ARTRealtimeChannel
    
    static let shared = AblyService()
    
    private init() {
        self.options = ARTClientOptions(token: "token")        
        self.client = ARTRealtime(options: options)
        self.queueChannel = client.channels.get("queuechannelName")
        self.gameChannel = client.channels.get("gameChannelName")
    }
    
    func update(with token: String, and queue: String) {
        self.options = ARTClientOptions(token: token)
        self.options.echoMessages = false
        
        self.client = ARTRealtime(options: options)
        self.queueChannel = client.channels.get(queue)
    }
    
    // Return client id of the currently logged in user.
    func getClientId() -> String? {
        self.client.auth.clientId
    }
    
    // Public methods for rest of the project to interact with: enter, leave queues.
    func enterQueue() {
        client.connection.on(.connected) { stateChange in
            NSLog("Connected to Ably.")
            self._enter()
        }
    }
    
    func leaveQueue() {
        self._leave()
    }
    
    // Public methods for rest of the project to interact with: enter, leave game.
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
    
    // Public methods for rest of the project to interact with: publish moves.
    func send(moves data: [String: Any]) {
        self._sendMove(with: data)
    }
  
    // QUEUES
    private func _enter() {
        NSLog("Entering channel \"\(self.queueChannel.name)\" queue.")
        
        self.queueChannel.subscribe("game") { [weak self] message in
            if let data = message.data as? [String: Any] {
                // Make sure that ids and username are the same to match correct accounts.
                if let payload = GameSessionDetails.toJSONAndDecode(data: data, type: GameSessionDetails.self) {
                    if payload.runner == self?.client.auth.clientId || payload.seeker == self?.client.auth.clientId {
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
        self.queueChannel.detach()
    }
    
    // GAME
    private func _enterGame() {
        guard let clientId = self.client.auth.clientId else { return }
        let channelName = "room:\(GameSessionDetails.shared.roomCode):\(clientId)"
        self.gameChannel = self.client.channels.get(channelName)
        
        NSLog("Entering channel \"\(channelName)\".")
        
        self.gameChannel.subscribe(GameSessionDetails.shared.roomCode) { message in
            if let data = message.data as? [String: Any] {
                
                print("Incoming data: \(message.data ?? "subscribe shared code error.")")
                
                // Decode as game config if type is inside the response and it equals to config.
                if let type = data["type"] as? String,
                    type == "config",
                    let payload = GameConfig.toJSONAndDecode(data: data, type: GameConfig.self) {
                    GameConfig.shared.update(with: payload)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("Success:GameConfig"), object: nil)
                    }
                }
                
                if let _ = data["playedBy"] as? String,
                    let payload = MoveResponse.toJSONAndDecode(data: data, type: MoveResponse.self) {
                    MoveResponse.shared.update(with: payload)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("Success:MoveResponse"), object: nil)
                    }
                }
                
                if let type = data["type"] as? String,
                    type == "game-over",
                    let payload = GameOver.toJSONAndDecode(data: data, type: GameOver.self) {
                    GameOver.shared.update(with: payload)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("Success:GameOver"), object: nil)
                    }
                }
            }
            
        }
        
        self.gameChannel.presence.enter(nil)
    }
    
    private func _leaveGame() {
        NSLog("Resigning from the game.")
        
        self.gameChannel.publish(GameSessionDetails.shared.roomCode, data: ["resign": true]) { error in
            if let error = error {
                print("Unable to publish message. Status code: \(error.statusCode). Error: \(error.message)")
            } else {
                NSLog("Leaving channel \"\(self.gameChannel.name)\".")
                self.gameChannel.unsubscribe()
                self.gameChannel.presence.leave(nil)
                self.gameChannel.detach()
            }
        }
    }
    
    // MOVES
    private func _sendMove(with data: [String: Any]) {
        self.gameChannel.publish(GameSessionDetails.shared.roomCode, data: data) { error in
          if let error = error {
              print("Unable to publish message. Status code: \(error.statusCode). Error: \(error.message)")
          } else {
            print("Message successfully sent")
          }
        }
    }
}
