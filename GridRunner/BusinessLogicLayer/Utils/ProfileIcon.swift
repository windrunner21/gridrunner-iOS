//
//  ProfileIcon.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 30.05.23.
//

class ProfileIcon {
    static let shared = ProfileIcon()
    
    private var icon: String
    private static let emojiList = ["🤣", "🤪", "🤭", "🤡", "🤙", "👋", "👅", "👀", "👾", "😼", "🐣", "🦁", "🐷", "🐺", "🌰", "🏃", "🏃‍♀️", "🥐", "💭"]
    
    convenience init() {
        self.init(icon: Self.randomEmoji())
    }
    
    private init(icon: String?) {
        self.icon = icon ?? ""
    }
    
    private static func randomEmoji() -> String? {
        self.emojiList.randomElement()
    }
    
    func getIcon() -> String {
        self.icon
    }
}
