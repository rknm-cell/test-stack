//
//  AdvancedFeedModels.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation

// MARK: - Advanced Feed Item Types
enum AdvancedFeedItemType: String, Codable {
    case trendingActivity = "trending_activity"
    case seasonalChallenge = "seasonal_challenge"
    case communityPlay = "community_play"
    case inspiration = "inspiration"
    case personalRecommendation = "personal_recommendation"
    case locationBased = "location_based"
    case timeBased = "time_based"
}

// MARK: - Advanced Feed Item Model
struct AdvancedFeedItem: Identifiable, Codable {
    let id: String
    let type: AdvancedFeedItemType
    let title: String
    let description: String
    let category: PlayCategory
    let emoji: String
    let popularityScore: Int
    let engagementScore: Double
    let location: String?
    let timeOfDay: String?
    let difficulty: DifficultyLevel
    let estimatedDuration: Int // in minutes
    let tags: [String]
    let createdAt: Date
    let expiresAt: Date?
    
    init(
        id: String = UUID().uuidString,
        type: AdvancedFeedItemType,
        title: String,
        description: String,
        category: PlayCategory,
        emoji: String,
        popularityScore: Int = 0,
        engagementScore: Double = 0.0,
        location: String? = nil,
        timeOfDay: String? = nil,
        difficulty: DifficultyLevel = .beginner,
        estimatedDuration: Int = 30,
        tags: [String] = [],
        createdAt: Date = Date(),
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.category = category
        self.emoji = emoji
        self.popularityScore = popularityScore
        self.engagementScore = engagementScore
        self.location = location
        self.timeOfDay = timeOfDay
        self.difficulty = difficulty
        self.estimatedDuration = estimatedDuration
        self.tags = tags
        self.createdAt = createdAt
        self.expiresAt = expiresAt
    }
    
    // Computed properties
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
    
    var popularityIndicator: String {
        switch popularityScore {
        case 0..<10:
            return "⭐"
        case 10..<25:
            return "🔥"
        case 25..<50:
            return "💫"
        default:
            return "��"
        }
    }
    
    var difficultyIndicator: String {
        switch difficulty {
        case .beginner:
            return "��"
        case .intermediate:
            return "🟡"
        case .advanced:
            return "🔴"
        }
    }
    
    var isExpired: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() > expiresAt
    }
    
    var timeRemaining: String? {
        guard let expiresAt = expiresAt else { return nil }
        let timeInterval = expiresAt.timeIntervalSinceNow
        if timeInterval <= 0 { return "Expired" }
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m left"
        } else {
            return "\(minutes)m left"
        }
    }
}

// MARK: - Difficulty Level
enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var color: String {
        switch self {
        case .beginner:
            return "green"
        case .intermediate:
            return "orange"
        case .advanced:
            return "red"
        }
    }
}

// MARK: - Personal Recommendation Model
struct PersonalRecommendation: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: PlayCategory
    let emoji: String
    let reason: String
    let confidence: Double // 0.0 to 1.0
    let basedOn: [String] // What this recommendation is based on
    
    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        category: PlayCategory,
        emoji: String,
        reason: String,
        confidence: Double,
        basedOn: [String]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.emoji = emoji
        self.reason = reason
        self.confidence = confidence
        self.basedOn = basedOn
    }
    
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
    
    var confidenceLevel: String {
        switch confidence {
        case 0.8...1.0:
            return "High"
        case 0.6..<0.8:
            return "Medium"
        default:
            return "Low"
        }
    }
}

// MARK: - Feed Analytics Model
struct FeedAnalytics: Codable {
    let totalItems: Int
    let itemsByType: [AdvancedFeedItemType: Int]
    let itemsByCategory: [PlayCategory: Int]
    let averageEngagement: Double
    let topTags: [String]
    let lastUpdated: Date
    
    init(
        totalItems: Int,
        itemsByType: [AdvancedFeedItemType: Int],
        itemsByCategory: [PlayCategory: Int],
        averageEngagement: Double,
        topTags: [String],
        lastUpdated: Date = Date()
    ) {
        self.totalItems = totalItems
        self.itemsByType = itemsByType
        self.itemsByCategory = itemsByCategory
        self.averageEngagement = averageEngagement
        self.topTags = topTags
        self.lastUpdated = lastUpdated
    }
}
