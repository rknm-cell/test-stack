//
//  CommunityView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct CommunityView: View {
    @StateObject private var viewModel = CommunityViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Bar
                CommunityTabBar(selectedTab: $viewModel.selectedTab)
                
                // Content based on selected tab
                TabView(selection: $viewModel.selectedTab) {
                    // Following Feed
                    FollowingFeedTab(viewModel: viewModel)
                        .tag(0)
                    
                    // Groups
                    GroupsTab(viewModel: viewModel)
                        .tag(1)
                    
                    // Discover
                    DiscoverTab(viewModel: viewModel)
                        .tag(2)
                    
                    // Profile
                    ProfileTab(viewModel: viewModel)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshCommunityData()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}

// MARK: - Community Tab Bar
struct CommunityTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        ("Following", "person.2"),
        ("Groups", "person.3"),
        ("Discover", "magnifyingglass"),
        ("Profile", "person.circle")
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

// MARK: - Following Feed Tab
struct FollowingFeedTab: View {
    @ObservedObject var viewModel: CommunityViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView("Loading community feed...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if viewModel.following.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "person.2")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No following yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Follow some users to see their play moments")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    ForEach(viewModel.following) { user in
                        UserProfileCard(user: user) {
                            if viewModel.isFollowing(user) {
                                viewModel.unfollowUser(user)
                            } else {
                                viewModel.followUser(user)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshCommunityData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Groups Tab
struct GroupsTab: View {
    @ObservedObject var viewModel: CommunityViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Bar
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search groups...", text: $viewModel.searchText)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button("All") {
                            viewModel.selectedCategory = nil
                        }
                        .buttonStyle(CategoryFilterButtonStyle(isSelected: viewModel.selectedCategory == nil))
                        
                        ForEach(PlayCategory.allCases, id: \.self) { category in
                            Button(category.rawValue) {
                                viewModel.selectedCategory = category
                            }
                            .buttonStyle(CategoryFilterButtonStyle(isSelected: viewModel.selectedCategory == category))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            
            // Groups List
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView("Loading groups...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else if viewModel.filteredGroups().isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "person.3")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text("No groups found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Try adjusting your search or filters")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                    } else {
                        ForEach(viewModel.filteredGroups()) { group in
                            ActivityGroupCard(group: group) {
                                if viewModel.isMemberOfGroup(group) {
                                    viewModel.leaveGroup(group)
                                } else {
                                    viewModel.joinGroup(group)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Discover Tab
struct DiscoverTab: View {
    @ObservedObject var viewModel: CommunityViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading discovery...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else {
                    // Suggested Users
                    if !viewModel.followers.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Suggested Users")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            ForEach(viewModel.followers) { user in
                                UserProfileCard(user: user) {
                                    if viewModel.isFollowing(user) {
                                        viewModel.unfollowUser(user)
                                    } else {
                                        viewModel.followUser(user)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Popular Groups
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Popular Groups")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        ForEach(viewModel.activityGroups.prefix(3)) { group in
                            ActivityGroupCard(group: group) {
                                if viewModel.isMemberOfGroup(group) {
                                    viewModel.leaveGroup(group)
                                } else {
                                    viewModel.joinGroup(group)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshCommunityData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - Profile Tab
struct ProfileTab: View {
    @ObservedObject var viewModel: CommunityViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading profile...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Your Profile")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Manage your community presence")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Following/Followers Stats
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(viewModel.following.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(viewModel.followers.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Followers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(viewModel.activityGroups.count)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Groups")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Your Groups
                    if !viewModel.activityGroups.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Your Groups")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            
                            ForEach(viewModel.activityGroups) { group in
                                ActivityGroupCard(group: group) {
                                    viewModel.leaveGroup(group)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshCommunityData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    continuation.resume()
                }
            }
        }
    }
}

#Preview {
    CommunityView()
}
