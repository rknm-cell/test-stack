//
//  DiscoveryFeedViewModel.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import Combine

class DiscoveryFeedViewModel: ObservableObject {
    @Published var feedItems: [FeedItem] = []
    @Published var seasonalChallenges: [SeasonalChallenge] = []
    @Published var trendingActivities: [FeedItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockData()
    }
    
    // MARK: - Data Loading
    func loadMockData() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.generateMockFeedItems()
            self.generateMockSeasonalChallenges()
            self.generateMockTrendingActivities()
            self.isLoading = false
        }
    }
    
    func refreshFeed() {
        loadMockData()
    }
    
    // MARK: - Mock Data Generation
    private func generateMockFeedItems() {
        feedItems = [
            FeedItem(
                type: .trendingActivity,
                title: "Creative Writing Challenge",
                description: "Join thousands of people exploring their creativity through daily writing prompts",
                category: .creative,
                emoji: "✍️",
                popularityScore: 45
            ),
            FeedItem(
                type: .communityPlay,
                title: "Morning Yoga Flow",
                description: "Start your day with gentle movement and mindfulness",
                category: .physical,
                emoji: "🧘‍♀️",
                popularityScore: 32
            ),
            FeedItem(
                type: .inspiration,
                title: "Cooking New Cuisines",
                description: "Discover the joy of exploring flavors from around the world",
                category: .creative,
                emoji: "🍳",
                popularityScore: 28
            ),
            FeedItem(
                type: .trendingActivity,
                title: "Language Learning Games",
                description: "Make learning a new language fun with interactive games",
                category: .learning,
                emoji: "🗣️",
                popularityScore: 38
            ),
            FeedItem(
                type: .communityPlay,
                title: "Board Game Nights",
                description: "Connect with friends through classic and modern board games",
                category: .social,
                emoji: "🎲",
                popularityScore: 25
            )
        ]
    }
    
    private func generateMockSeasonalChallenges() {
        seasonalChallenges = [
            SeasonalChallenge(
                title: "30-Day Creative Challenge",
                description: "Explore a new creative activity every day for 30 days",
                category: .creative,
                emoji: "🎨",
                participants: 1250
            ),
            SeasonalChallenge(
                title: "Mindful Movement Week",
                description: "Focus on gentle, mindful movement and stretching",
                category: .physical,
                emoji: "🤸‍♀️",
                participants: 890
            ),
            SeasonalChallenge(
                title: "Social Connection Challenge",
                description: "Reach out to someone new or reconnect with old friends",
                category: .social,
                emoji: "🤝",
                participants: 2100
            )
        ]
    }
    
    private func generateMockTrendingActivities() {
        trendingActivities = [
            FeedItem(
                type: .trendingActivity,
                title: "Digital Art Creation",
                description: "Express yourself through digital painting and illustration",
                category: .creative,
                emoji: "🎨",
                popularityScore: 52
            ),
            FeedItem(
                type: .trendingActivity,
                title: "Outdoor Photography",
                description: "Capture the beauty of nature and urban landscapes",
                category: .creative,
                emoji: "📸",
                popularityScore: 41
            ),
            FeedItem(
                type: .trendingActivity,
                title: "Meditation & Mindfulness",
                description: "Find peace and clarity through guided meditation",
                category: .relaxation,
                emoji: "🧘‍♂️",
                popularityScore: 48
            )
        ]
    }
    
    // MARK: - Actions
    func joinChallenge(_ challenge: SeasonalChallenge) {
        // TODO: Implement challenge joining logic
        print("Joining challenge: \(challenge.title)")
    }
    
    func exploreActivity(_ activity: FeedItem) {
        // TODO: Implement activity exploration logic
        print("Exploring activity: \(activity.title)")
    }
}
