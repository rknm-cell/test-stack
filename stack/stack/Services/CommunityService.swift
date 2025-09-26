//
//  CommunityService.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import Combine

class CommunityService: ObservableObject {
    @Published var following: [UserProfile] = []
    @Published var followers: [UserProfile] = []
    @Published var activityGroups: [ActivityGroup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadMockData()
    }
    
    // MARK: - Data Loading
    func loadMockData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.generateMockFollowing()
            self.generateMockFollowers()
            self.generateMockActivityGroups()
            self.isLoading = false
        }
    }
    
    func refreshCommunityData() {
        loadMockData()
    }
    
    // MARK: - Following Management
    func followUser(_ user: UserProfile) {
        if !following.contains(where: { $0.id == user.id }) {
            following.append(user)
            saveFollowing()
        }
    }
    
    func unfollowUser(_ user: UserProfile) {
        following.removeAll { $0.id == user.id }
        saveFollowing()
    }
    
    func isFollowing(_ user: UserProfile) -> Bool {
        following.contains { $0.id == user.id }
    }
    
    // MARK: - Activity Groups Management
    func joinGroup(_ group: ActivityGroup) {
        if !activityGroups.contains(where: { $0.id == group.id }) {
            activityGroups.append(group)
            saveActivityGroups()
        }
    }
    
    func leaveGroup(_ group: ActivityGroup) {
        activityGroups.removeAll { $0.id == group.id }
        saveActivityGroups()
    }
    
    func isMemberOfGroup(_ group: ActivityGroup) -> Bool {
        activityGroups.contains { $0.id == group.id }
    }
    
    func createGroup(name: String, description: String, category: PlayCategory, emoji: String, isPublic: Bool = true) -> ActivityGroup {
        let group = ActivityGroup(
            name: name,
            description: description,
            category: category,
            emoji: emoji,
            createdBy: "current_user_id", // This would be the actual current user ID
            isPublic: isPublic
        )
        
        activityGroups.append(group)
        saveActivityGroups()
        return group
    }
    
    // MARK: - Data Persistence
    private func saveFollowing() {
        if let data = try? JSONEncoder().encode(following) {
            userDefaults.set(data, forKey: "saved_following")
        }
    }
    
    private func loadFollowing() {
        if let data = userDefaults.data(forKey: "saved_following"),
           let following = try? JSONDecoder().decode([UserProfile].self, from: data) {
            self.following = following
        }
    }
    
    private func saveActivityGroups() {
        if let data = try? JSONEncoder().encode(activityGroups) {
            userDefaults.set(data, forKey: "saved_activity_groups")
        }
    }
    
    private func loadActivityGroups() {
        if let data = userDefaults.data(forKey: "saved_activity_groups"),
           let groups = try? JSONDecoder().decode([ActivityGroup].self, from: data) {
            self.activityGroups = groups
        }
    }
    
    // MARK: - Mock Data Generation
    private func generateMockFollowing() {
        following = [
            UserProfile(
                id: "user_1",
                name: "Creative Explorer",
                email: "creative@example.com",
                bio: "Passionate about creative activities and inspiring others",
                totalPlayEntries: 45,
                currentStreak: 12,
                favoriteCategories: [.creative, .learning],
                isVerified: true
            ),
            UserProfile(
                id: "user_2",
                name: "Mindful Mover",
                email: "mindful@example.com",
                bio: "Finding balance through movement and mindfulness",
                totalPlayEntries: 32,
                currentStreak: 8,
                favoriteCategories: [.physical, .relaxation],
                isVerified: false
            ),
            UserProfile(
                id: "user_3",
                name: "Social Connector",
                email: "social@example.com",
                bio: "Building community through shared experiences",
                totalPlayEntries: 28,
                currentStreak: 15,
                favoriteCategories: [.social, .creative],
                isVerified: true
            )
        ]
    }
    
    private func generateMockFollowers() {
        followers = [
            UserProfile(
                id: "follower_1",
                name: "Play Enthusiast",
                email: "play@example.com",
                bio: "New to the community, excited to explore!",
                totalPlayEntries: 5,
                currentStreak: 3,
                favoriteCategories: [.general],
                isVerified: false
            ),
            UserProfile(
                id: "follower_2",
                name: "Creative Soul",
                email: "soul@example.com",
                bio: "Artist and creative thinker",
                totalPlayEntries: 18,
                currentStreak: 6,
                favoriteCategories: [.creative, .learning],
                isVerified: false
            )
        ]
    }
    
    private func generateMockActivityGroups() {
        activityGroups = [
            ActivityGroup(
                name: "Creative Writers",
                description: "A community for writers of all levels to share their work and get inspired",
                category: .creative,
                emoji: "✍️",
                createdBy: "user_1",
                memberCount: 1250,
                tags: ["writing", "creativity", "literature", "poetry"],
                rules: ["Be respectful", "Share original work", "Provide constructive feedback"]
            ),
            ActivityGroup(
                name: "Morning Movers",
                description: "Start your day with movement and mindfulness",
                category: .physical,
                emoji: "🧘‍♀️",
                createdBy: "user_2",
                memberCount: 890,
                tags: ["yoga", "meditation", "morning", "mindfulness"],
                rules: ["Share your morning routine", "Encourage others", "Stay positive"]
            ),
            ActivityGroup(
                name: "Social Gamers",
                description: "Connect through board games, card games, and social activities",
                category: .social,
                emoji: "🎲",
                createdBy: "user_3",
                memberCount: 2100,
                tags: ["games", "social", "board games", "cards"],
                rules: ["Be inclusive", "Share game recommendations", "Have fun"]
            )
        ]
    }
}
