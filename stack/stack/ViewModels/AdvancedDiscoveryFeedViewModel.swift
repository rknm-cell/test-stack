//
//  AdvancedDiscoveryFeedViewModel.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import Combine

class AdvancedDiscoveryFeedViewModel: ObservableObject {
    @Published var feedItems: [AdvancedFeedItem] = []
    @Published var personalRecommendations: [PersonalRecommendation] = []
    @Published var seasonalChallenges: [SeasonalChallenge] = []
    @Published var trendingActivities: [AdvancedFeedItem] = []
    @Published var locationBasedItems: [AdvancedFeedItem] = []
    @Published var timeBasedItems: [AdvancedFeedItem] = []
    @Published var feedAnalytics: FeedAnalytics?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedFilter: FeedFilter = .all
    @Published var selectedCategory: PlayCategory? = nil
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchBinding()
        loadMockData()
    }
    
    // MARK: - Search Binding
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterItems()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    func loadMockData() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.generateMockFeedItems()
            self.generateMockPersonalRecommendations()
            self.generateMockSeasonalChallenges()
            self.generateMockTrendingActivities()
            self.generateMockLocationBasedItems()
            self.generateMockTimeBasedItems()
            self.calculateAnalytics()
            self.isLoading = false
        }
    }
    
    func refreshFeed() {
        loadMockData()
    }
    
    // MARK: - Filtering
    func filterItems() {
        // This would typically filter the data based on search text and filters
        // For now, we'll just reload the data
        loadMockData()
    }
    
    // MARK: - Mock Data Generation
    private func generateMockFeedItems() {
        feedItems = [
            AdvancedFeedItem(
                type: .trendingActivity,
                title: "Creative Writing Challenge",
                description: "Join thousands of people exploring their creativity through daily writing prompts",
                category: .creative,
                emoji: "✍️",
                popularityScore: 45,
                engagementScore: 0.85,
                difficulty: .beginner,
                estimatedDuration: 20,
                tags: ["writing", "creativity", "daily", "challenge"]
            ),
            AdvancedFeedItem(
                type: .communityPlay,
                title: "Morning Yoga Flow",
                description: "Start your day with gentle movement and mindfulness",
                category: .physical,
                emoji: "🧘‍♀️",
                popularityScore: 32,
                engagementScore: 0.78,
                timeOfDay: "Morning",
                difficulty: .beginner,
                estimatedDuration: 30,
                tags: ["yoga", "morning", "mindfulness", "movement"]
            ),
            AdvancedFeedItem(
                type: .inspiration,
                title: "Cooking New Cuisines",
                description: "Discover the joy of exploring flavors from around the world",
                category: .creative,
                emoji: "🍳",
                popularityScore: 28,
                engagementScore: 0.72,
                difficulty: .intermediate,
                estimatedDuration: 60,
                tags: ["cooking", "cuisine", "exploration", "flavors"]
            ),
            AdvancedFeedItem(
                type: .trendingActivity,
                title: "Language Learning Games",
                description: "Make learning a new language fun with interactive games",
                category: .learning,
                emoji: "🗣️",
                popularityScore: 38,
                engagementScore: 0.81,
                difficulty: .beginner,
                estimatedDuration: 25,
                tags: ["language", "learning", "games", "interactive"]
            ),
            AdvancedFeedItem(
                type: .communityPlay,
                title: "Board Game Nights",
                description: "Connect with friends through classic and modern board games",
                category: .social,
                emoji: "🎲",
                popularityScore: 25,
                engagementScore: 0.69,
                timeOfDay: "Evening",
                difficulty: .beginner,
                estimatedDuration: 120,
                tags: ["board games", "social", "friends", "evening"]
            )
        ]
    }
    
    private func generateMockPersonalRecommendations() {
        personalRecommendations = [
            PersonalRecommendation(
                title: "Watercolor Painting",
                description: "Based on your interest in creative activities, try watercolor painting",
                category: .creative,
                emoji: "��",
                reason: "You've shown interest in creative activities and haven't tried painting yet",
                confidence: 0.85,
                basedOn: ["Creative category preference", "No painting activities logged"]
            ),
            PersonalRecommendation(
                title: "Meditation Practice",
                description: "Start a daily meditation practice to complement your physical activities",
                category: .relaxation,
                emoji: "🧘‍♂️",
                reason: "You enjoy physical activities and meditation would provide balance",
                confidence: 0.72,
                basedOn: ["Physical activity patterns", "Stress level indicators"]
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
            AdvancedFeedItem(
                type: .trendingActivity,
                title: "Digital Art Creation",
                description: "Express yourself through digital painting and illustration",
                category: .creative,
                emoji: "🎨",
                popularityScore: 52,
                engagementScore: 0.88,
                difficulty: .intermediate,
                estimatedDuration: 45,
                tags: ["digital art", "painting", "illustration", "creativity"]
            ),
            AdvancedFeedItem(
                type: .trendingActivity,
                title: "Outdoor Photography",
                description: "Capture the beauty of nature and urban landscapes",
                category: .creative,
                emoji: "📸",
                popularityScore: 41,
                engagementScore: 0.79,
                difficulty: .beginner,
                estimatedDuration: 60,
                tags: ["photography", "outdoor", "nature", "landscapes"]
            ),
            AdvancedFeedItem(
                type: .trendingActivity,
                title: "Meditation & Mindfulness",
                description: "Find peace and clarity through guided meditation",
                category: .relaxation,
                emoji: "🧘‍♂️",
                popularityScore: 48,
                engagementScore: 0.83,
                difficulty: .beginner,
                estimatedDuration: 15,
                tags: ["meditation", "mindfulness", "peace", "clarity"]
            )
        ]
    }
    
    private func generateMockLocationBasedItems() {
        locationBasedItems = [
            AdvancedFeedItem(
                type: .locationBased,
                title: "Local Art Gallery Visit",
                description: "Explore contemporary art at the nearby gallery",
                category: .creative,
                emoji: "🖼️",
                popularityScore: 15,
                engagementScore: 0.65,
                location: "Downtown",
                difficulty: .beginner,
                estimatedDuration: 90,
                tags: ["art", "gallery", "local", "culture"]
            )
        ]
    }
    
    private func generateMockTimeBasedItems() {
        timeBasedItems = [
            AdvancedFeedItem(
                type: .timeBased,
                title: "Evening Stargazing",
                description: "Perfect time to observe the night sky and constellations",
                category: .relaxation,
                emoji: "⭐",
                popularityScore: 12,
                engagementScore: 0.58,
                timeOfDay: "Evening",
                difficulty: .beginner,
                estimatedDuration: 45,
                tags: ["stargazing", "evening", "nature", "relaxation"]
            )
        ]
    }
    
    private func calculateAnalytics() {
        let itemsByType = Dictionary(grouping: feedItems, by: { $0.type })
            .mapValues { $0.count }
        
        let itemsByCategory = Dictionary(grouping: feedItems, by: { $0.category })
            .mapValues { $0.count }
        
        let averageEngagement = feedItems.isEmpty ? 0.0 : 
            feedItems.map { $0.engagementScore }.reduce(0, +) / Double(feedItems.count)
        
        let allTags = feedItems.flatMap { $0.tags }
        let topTags = Array(Set(allTags)).prefix(5).map { String($0) }
        
        feedAnalytics = FeedAnalytics(
            totalItems: feedItems.count,
            itemsByType: itemsByType,
            itemsByCategory: itemsByCategory,
            averageEngagement: averageEngagement,
            topTags: topTags
        )
    }
    
    // MARK: - Actions
    func joinChallenge(_ challenge: SeasonalChallenge) {
        print("Joining challenge: \(challenge.title)")
    }
    
    func exploreActivity(_ activity: AdvancedFeedItem) {
        print("Exploring activity: \(activity.title)")
    }
    
    func exploreRecommendation(_ recommendation: PersonalRecommendation) {
        print("Exploring recommendation: \(recommendation.title)")
    }
}

// MARK: - Feed Filter
enum FeedFilter: String, CaseIterable {
    case all = "All"
    case trending = "Trending"
    case personal = "Personal"
    case location = "Location"
    case time = "Time"
    case challenges = "Challenges"
}