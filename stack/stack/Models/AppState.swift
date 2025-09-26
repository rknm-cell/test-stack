//
//  AppState.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var playEntries: [PlayEntry] = []
    
    // MARK: - Authentication
    func signIn(){
        let mockUser = User(
            id: "user_123",
            name: "Play Enthusiast",
            email: "user@example.com"
        )
        isAuthenticated = true
        currentUser = mockUser
        errorMessage = nil
    }
    
    func signOut(){
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
        playEntries = [] // Clear play entries on sign out
    }
    
    // MARK: - Play Entries Management
    func addPlayEntry(_ entry: PlayEntry) {
        playEntries.insert(entry, at: 0) // Add to beginning for newest first
    }
    
    func deletePlayEntry(withId id: String) {
        playEntries.removeAll { $0.id == id }
    }
    
    // MARK: - Computed Properties
    var hasLoggedPlay: Bool {
        !playEntries.isEmpty
    }
    
    var totalPlayEntries: Int {
        playEntries.count
    }
    
    var playEntriesByCategory: [PlayCategory: Int] {
        Dictionary(grouping: playEntries, by: { $0.category })
            .mapValues { $0.count }
    }
}

struct User {
    let id: String
    let name: String
    let email: String
}
