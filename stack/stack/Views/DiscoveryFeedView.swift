//
//  DiscoveryFeedView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct DiscoveryFeedView: View {
    @StateObject private var viewModel = DiscoveryFeedViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
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
                                    TrendingActivityCard(activity: activity) {
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
                                FeedItemCard(item: item) {
                                    viewModel.exploreActivity(item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 20)
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
            .refreshable {
                await withCheckedContinuation { continuation in
                    viewModel.refreshFeed()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        continuation.resume()
                    }
                }
            }
        }
    }
}

// MARK: - Card Components
struct SeasonalChallengeCard: View {
    let challenge: SeasonalChallenge
    let onJoin: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.emoji)
                    .font(.title)
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(challenge.displayCategory)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            Text(challenge.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label("\(challenge.participants)", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if challenge.daysRemaining > 0 {
                    Text("\(challenge.daysRemaining) days left")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Button("Join Challenge") {
                onJoin()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .frame(width: 280)
    }
}

struct TrendingActivityCard: View {
    let activity: FeedItem
    let onExplore: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Text(activity.emoji)
                .font(.title)
                .frame(width: 50, height: 50)
                .background(Color(.systemGray5))
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(activity.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(activity.popularityIndicator)
                        .font(.caption)
                }
                
                Text(activity.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(activity.displayCategory)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Trending")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            
            Button("Explore") {
                onExplore()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct FeedItemCard: View {
    let item: FeedItem
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
    DiscoveryFeedView()
}
```

