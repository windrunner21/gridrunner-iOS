//
//  ProfileIcon.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 30.05.23.
//

struct ProfileIcon {
    private var emoji: String {
        randomEmoji() ?? "🧶"
    }
    
    private let emojiList = ["🤣", "🤪", "🤭", "🤡", "🤙", "👋", "👅", "👀", "👾", "😼", "🐣", "🦁", "🐷", "🐺", "🌰", "🏃", "🏃‍♀️", "🥐", "💭"]
    
    private func randomEmoji() -> String? {
        self.emojiList.randomElement()
    }
    
    func getEmoji() -> String {
        self.emoji
    }
}
