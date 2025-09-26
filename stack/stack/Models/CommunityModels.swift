//
//  CommunityModels.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation

// MARK: - User Profile Model
struct UserProfile: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let bio: String?
    let avatar: String?
    let joinDate: Date
    let totalPlayEntries: Int
    let currentStreak: Int
    let favoriteCategories: [PlayCategory]
    let isVerified: Bool
    let isPrivate: Bool
    
    init(
        id: String,
        name: String,
        email: String,
        bio: String? = nil,
        avatar: String? = nil,
        joinDate: Date = Date(),
        totalPlayEntries: Int = 0,
        currentStreak: Int = 0,
        favoriteCategories: [PlayCategory] = [],
        isVerified: Bool = false,
        isPrivate: Bool = false
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.bio = bio
        self.avatar = avatar
        self.joinDate = joinDate
        self.totalPlayEntries = totalPlayEntries
        self.currentStreak = currentStreak
        self.favoriteCategories = favoriteCategories
        self.isVerified = isVerified
        self.isPrivate = isPrivate
    }
    
    var displayName: String {
        return isVerified ? "\(name) ✓" : name
    }
    
    var joinDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: joinDate)
    }
}

// MARK: - Following Relationship Model
struct FollowingRelationship: Identifiable, Codable {
    let id: String
    let followerId: String
    let followingId: String
    let createdAt: Date
    let isActive: Bool
    
    init(
        id: String = UUID().uuidString,
        followerId: String,
        followingId: String,
        createdAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.followerId = followerId
        self.followingId = followingId
        self.createdAt = createdAt
        self.isActive = isActive
    }
}

// MARK: - Activity Group Model
struct ActivityGroup: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let category: PlayCategory
    let emoji: String
    let createdBy: String
    let createdAt: Date
    let memberCount: Int
    let isPublic: Bool
    let tags: [String]
    let rules: [String]
    let isActive: Bool
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        category: PlayCategory,
        emoji: String,
        createdBy: String,
        createdAt: Date = Date(),
        memberCount: Int = 1,
        isPublic: Bool = true,
        tags: [String] = [],
        rules: [String] = [],
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.emoji = emoji
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.memberCount = memberCount
        self.isPublic = isPublic
        self.tags = tags
        self.rules = rules
        self.isActive = isActive
    }
    
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
    
    var createdAtFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
}
