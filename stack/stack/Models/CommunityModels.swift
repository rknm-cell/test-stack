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

// MARK: - Group Membership Model
struct GroupMembership: Identifiable, Codable {
    let id: String
    let groupId: String
    let userId: String
    let joinedAt: Date
    let role: GroupRole
    let isActive: Bool
    
    init(
        id: String = UUID().uuidString,
        groupId: String,
        userId: String,
        joinedAt: Date = Date(),
        role: GroupRole = .member,
        isActive: Bool = true
    ) {
        self.id = id
        self.groupId = groupId
        self.userId = userId
        self.joinedAt = joinedAt
        self.role = role
        self.isActive = isActive
    }
}

// MARK: - Group Role
enum GroupRole: String, CaseIterable, Codable {
    case member = "Member"
    case moderator = "Moderator"
    case admin = "Admin"
    case owner = "Owner"
    
    var permissions: [GroupPermission] {
        switch self {
        case .member:
            return [.view, .post]
        case .moderator:
            return [.view, .post, .moderate]
        case .admin:
            return [.view, .post, .moderate, .manageMembers]
        case .owner:
            return [.view, .post, .moderate, .manageMembers, .manageGroup]
        }
    }
}

// MARK: - Group Permission
enum GroupPermission: String, CaseIterable, Codable {
    case view = "View"
    case post = "Post"
    case moderate = "Moderate"
    case manageMembers = "Manage Members"
    case manageGroup = "Manage Group"
}

// MARK: - Community Post Model
struct CommunityPost: Identifiable, Codable {
    let id: String
    let authorId: String
    let authorName: String
    let groupId: String?
    let content: String
    let category: PlayCategory
    let createdAt: Date
    let isPublic: Bool
    let tags: [String]
    let engagement: PostEngagement
    
    init(
        id: String = UUID().uuidString,
        authorId: String,
        authorName: String,
        groupId: String? = nil,
        content: String,
        category: PlayCategory,
        createdAt: Date = Date(),
        isPublic: Bool = true,
        tags: [String] = [],
        engagement: PostEngagement = PostEngagement()
    ) {
        self.id = id
        self.authorId = authorId
        self.authorName = authorName
        self.groupId = groupId
        self.content = content
        self.category = category
        self.createdAt = createdAt
        self.isPublic = isPublic
        self.tags = tags
        self.engagement = engagement
    }
    
    var displayCategory: String {
        return "\(category.emoji) \(category.rawValue)"
    }
    
    var createdAtFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

// MARK: - Post Engagement Model
struct PostEngagement: Codable {
    let views: Int
    let shares: Int
    let comments: Int
    let inspired: Int // No likes, but "inspired" count
    
    init(
        views: Int = 0,
        shares: Int = 0,
        comments: Int = 0,
        inspired: Int = 0
    ) {
        self.views = views
        self.shares = shares
        self.comments = comments
        self.inspired = inspired
    }
}

// MARK: - Community Statistics Model
struct CommunityStatistics: Codable {
    let totalUsers: Int
    let totalGroups: Int
    let totalPosts: Int
    let activeUsers: Int
    let newUsersToday: Int
    let topCategories: [PlayCategory: Int]
    let topGroups: [String: Int] // Group ID to member count
    let lastUpdated: Date
    
    init(
        totalUsers: Int,
        totalGroups: Int,
        totalPosts: Int,
        activeUsers: Int,
        newUsersToday: Int,
        topCategories: [PlayCategory: Int],
        topGroups: [String: Int],
        lastUpdated: Date = Date()
    ) {
        self.totalUsers = totalUsers
        self.totalGroups = totalGroups
        self.totalPosts = totalPosts
        self.activeUsers = activeUsers
        self.newUsersToday = newUsersToday
        self.topCategories = topCategories
        self.topGroups = topGroups
        self.lastUpdated = lastUpdated
    }
}
