//
//  CommunityViewModel.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import Combine

class CommunityViewModel: ObservableObject {
    @Published var selectedTab = 0
    @Published var searchText = ""
    @Published var selectedCategory: PlayCategory? = nil
    @Published var showingCreateGroup = false
    
    private let communityService = CommunityService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Computed Properties
    var following: [UserProfile] {
        communityService.following
    }
    
    var followers: [UserProfile] {
        communityService.followers
    }
    
    var activityGroups: [ActivityGroup] {
        communityService.activityGroups
    }
    
    var isLoading: Bool {
        communityService.isLoading
    }
    
    var errorMessage: String? {
        communityService.errorMessage
    }
    
    // MARK: - Actions
    func refreshCommunityData() {
        communityService.refreshCommunityData()
    }
    
    func followUser(_ user: UserProfile) {
        communityService.followUser(user)
    }
    
    func unfollowUser(_ user: UserProfile) {
        communityService.unfollowUser(user)
    }
    
    func isFollowing(_ user: UserProfile) -> Bool {
        communityService.isFollowing(user)
    }
    
    func joinGroup(_ group: ActivityGroup) {
        communityService.joinGroup(group)
    }
    
    func leaveGroup(_ group: ActivityGroup) {
        communityService.leaveGroup(group)
    }
    
    func isMemberOfGroup(_ group: ActivityGroup) -> Bool {
        communityService.isMemberOfGroup(group)
    }
    
    func createGroup(name: String, description: String, category: PlayCategory, emoji: String, isPublic: Bool = true) -> ActivityGroup {
        return communityService.createGroup(
            name: name,
            description: description,
            category: category,
            emoji: emoji,
            isPublic: isPublic
        )
    }
    
    // MARK: - Search
    private func performSearch() {
        // This would typically filter the data based on search text
        // For now, we'll just refresh the data
        refreshCommunityData()
    }
    
    // MARK: - Filtering
    func filteredGroups() -> [ActivityGroup] {
        var groups = activityGroups
        
        if let category = selectedCategory {
            groups = groups.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            groups = groups.filter { group in
                group.name.localizedCaseInsensitiveContains(searchText) ||
                group.description.localizedCaseInsensitiveContains(searchText) ||
                group.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return groups
    }
    
    func filteredUsers() -> [UserProfile] {
        var users = following + followers
        
        if !searchText.isEmpty {
            users = users.filter { user in
                user.name.localizedCaseInsensitiveContains(searchText) ||
                (user.bio?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return users
    }
}
