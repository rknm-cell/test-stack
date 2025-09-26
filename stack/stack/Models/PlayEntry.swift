//
//  PlayEntry.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation

// MARK: - Play Categories
enum PlayCategory: String, CaseIterable, Codable {
    case general = "General"
    case creative = "Creative"
    case physical = "Physical"
    case social = "Social"
    case learning = "Learning"
    case relaxation = "Relaxation"
    
    var emoji: String {
        switch self {
        case .general:
            return "🎮"
        case .creative:
            return "🎨"
        case .physical:
            return "🏃‍♂️"
        case .social:
            return "👥"
        case .learning:
            return "📚"
        case .relaxation:
            return "🧘‍♀️"
        }
    }
}

struct PlayEntry: Identifiable, Codable {
    let id: String
    let userId: String
    let description: String
    let category: PlayCategory
    let date: Date
    let createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        description: String,
        category: PlayCategory,
        date: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.description = description
        self.category = category
        self.date = date
        self.createdAt = createdAt
    }
    
    // Computed property for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Computed property for display
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
}
