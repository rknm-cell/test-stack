//
//  FeedItem.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation

// MARK: - Feed Item Types
enum FeedItemType: String, Codable {
    case trendingActivity = "trending_activity"
    case seasonalChallenge = "seasonal_challenge"
    case communityPlay = "community_play"
    case inspiration = "inspiration"
}

// MARK: - Feed Item Model
struct FeedItem: Identifiable, Codable {
    let id: String
    let type: FeedItemType
    let title: String
    let description: String
    let category: PlayCategory
    let emoji: String
    let popularityScore: Int
    let createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        type: FeedItemType,
        title: String,
        description: String,
        category: PlayCategory,
        emoji: String,
        popularityScore: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.category = category
        self.emoji = emoji
        self.popularityScore = popularityScore
        self.createdAt = createdAt
    }
    
    // Computed property for display
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
    
    // Computed property for popularity indicator
    var popularityIndicator: String {
        switch popularityScore {
        case 0..<10:
            return "��"
        case 10..<25:
            return "🔥"
        case 25..<50:
            return "💫"
        default:
            return "🚀"
        }
    }
}

// MARK: - Seasonal Challenge Model
struct SeasonalChallenge: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: PlayCategory
    let emoji: String
    let startDate: Date
    let endDate: Date
    let participants: Int
    let isActive: Bool
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        category: PlayCategory,
        emoji: String,
        startDate: Date = Date(),
        endDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
        participants: Int = 0,
        isActive: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.emoji = emoji
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.isActive = isActive
    }
    
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
    
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }
}
