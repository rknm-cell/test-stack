//
//  AdvancedDiscoveryFeedView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct AdvancedDiscoveryFeedView: View {
    @StateObject private var viewModel = AdvancedDiscoveryFeedViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
                
                // Content based on selected tab
                TabView(selection: $selectedTab) {
                    // All Feed
                    AllFeedTab(viewModel: viewModel)
                        .tag(0)
                    
                    // Personal Recommendations
                    PersonalRecommendationsTab(viewModel: viewModel)
                        .tag(1)
                    
                    // Trending
                    TrendingTab(viewModel: viewModel)
                        .tag(2)
                    
                    // Challenges
                    ChallengesTab(viewModel: viewModel)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Discovery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshFeed()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        ("All", "square.grid.2x2"),
        ("Personal", "person.crop.circle"),
        ("Trending", "flame"),
        ("Challenges", "trophy")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].1)
                            .font(.system(size: 16, weight: .medium))
                        Text(tabs[index].0)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == index ? .blue : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .bottom
        )
    }
}

// MARK: - All Feed Tab
struct AllFeedTab: View {
    @ObservedObject var viewModel: AdvancedDiscoveryFeedViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading inspiration...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else {
                    // Welcome Header
                    VStack(spacing: 12) {
                        Text("🌟")
                            .font(.system(size: 50))
                        Text("Discover Play")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Find inspiration for your next creative adventure")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Personal Recommendations Section
                    if !viewModel.personalRecommendations.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🎯 For You")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ForEach(viewModel.personalRecommendations) { recommendation in
                                PersonalRecommendationCard(recommendation: recommendation) {
                                    viewModel.exploreRecommendation(recommendation)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Seasonal Challenges Section
                    if !viewModel.seasonalChallenges.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🎯 Seasonal Challenges")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.seasonalChallenges) { challenge in
                                        SeasonalChallengeCard(challenge: challenge) {
                                            viewModel.joinChallenge(challenge)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Trending Activities Section
                    if !viewModel.trendingActivities.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🔥 Trending Activities")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ForEach(viewModel.trendingActivities) { activity in
                                AdvancedTrendingActivityCard(activity: activity) {
                                    viewModel.exploreActivity(activity)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Feed Items Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("✨ Community Inspiration")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.feedItems) { item in
                            AdvancedFeedItemCard(item: item) {
                                viewModel.exploreActivity(item)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshFeed()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Personal Recommendations Tab
struct PersonalRecommendationsTab: View {
    @ObservedObject var viewModel: AdvancedDiscoveryFeedViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading recommendations...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if viewModel.personalRecommendations.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No recommendations yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Log more play activities to get personalized recommendations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    ForEach(viewModel.personalRecommendations) { recommendation in
                        PersonalRecommendationCard(recommendation: recommendation) {
                            viewModel.exploreRecommendation(recommendation)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshFeed()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Trending Tab
struct TrendingTab: View {
    @ObservedObject var viewModel: AdvancedDiscoveryFeedViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading trending activities...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if viewModel.trendingActivities.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "flame")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No trending activities")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    ForEach(viewModel.trendingActivities) { activity in
                        AdvancedTrendingActivityCard(activity: activity) {
                            viewModel.exploreActivity(activity)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshFeed()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Challenges Tab
struct ChallengesTab: View {
    @ObservedObject var viewModel: AdvancedDiscoveryFeedViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading challenges...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if viewModel.seasonalChallenges.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "trophy")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No challenges available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    ForEach(viewModel.seasonalChallenges) { challenge in
                        SeasonalChallengeCard(challenge: challenge) {
                            viewModel.joinChallenge(challenge)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshFeed()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Advanced Card Components
struct PersonalRecommendationCard: View {
    let recommendation: PersonalRecommendation
    let onExplore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(recommendation.emoji)
                    .font(.title)
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(recommendation.displayCategory)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("For You")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                    Text(recommendation.confidenceLevel)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(recommendation.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Why we recommend this:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Text(recommendation.reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Spacer()
                Button("Try This") {
                    onExplore()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

struct AdvancedTrendingActivityCard: View {
    let activity: AdvancedFeedItem
    let onExplore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(activity.emoji)
                    .font(.title)
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(activity.displayCategory)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(activity.popularityIndicator)
                        .font(.caption)
                    Text("Trending")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
            
            Text(activity.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Activity Details
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(activity.estimatedDuration)m")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Text(activity.difficultyIndicator)
                    Text(activity.difficulty.rawValue)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                if let timeOfDay = activity.timeOfDay {
                    HStack(spacing: 4) {
                        Image(systemName: "sun.max")
                            .font(.caption)
                        Text(timeOfDay)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Tags
            if !activity.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(activity.tags.prefix(5), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                Button("Explore") {
                    onExplore()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct AdvancedFeedItemCard: View {
    let item: AdvancedFeedItem
    let onExplore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(item.emoji)
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(item.displayCategory)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(item.popularityIndicator)
                    .font(.caption)
            }
            
            Text(item.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Activity Details
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(item.estimatedDuration)m")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Text(item.difficultyIndicator)
                    Text(item.difficulty.rawValue)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                if let location = item.location {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.caption)
                        Text(location)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                Button("Get Inspired") {
                    onExplore()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    AdvancedDiscoveryFeedView()
}

