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
    
    // Services
    private let authenticationService = AuthenticationService()
    private let dataPersistenceService = DataPersistenceService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Bind authentication service to app state
        authenticationService.$isAuthenticated
            .assign(to: \.isAuthenticated, on: self)
            .store(in: &cancellables)
        
        authenticationService.$currentUser
            .assign(to: \.currentUser, on: self)
            .store(in: &cancellables)
        
        authenticationService.$errorMessage
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Authentication
    func signInWithApple() {
        authenticationService.signInWithApple()
    }
    
    func signInWithMock() {
        authenticationService.signInWithMock()
    }
    
    func signOut() {
        authenticationService.signOut()
        dataPersistenceService.playEntries = [] // Clear data on sign out
    }
    
    // MARK: - Play Entries Management
    var playEntries: [PlayEntry] {
        dataPersistenceService.playEntries
    }
    
    func addPlayEntry(_ entry: PlayEntry) {
        dataPersistenceService.addPlayEntry(entry)
    }
    
    func deletePlayEntry(withId id: String) {
        dataPersistenceService.deletePlayEntry(withId: id)
    }
    
    func updatePlayEntry(_ entry: PlayEntry) {
        dataPersistenceService.updatePlayEntry(entry)
    }
    
    // MARK: - Computed Properties
    var hasLoggedPlay: Bool {
        dataPersistenceService.hasLoggedPlay
    }
    
    var totalPlayEntries: Int {
        dataPersistenceService.totalPlayEntries
    }
    
    var playEntriesByCategory: [PlayCategory: Int] {
        dataPersistenceService.playEntriesByCategory
    }
    
    var currentStreak: Int {
        dataPersistenceService.currentStreak
    }
    
    // MARK: - Data Export/Import
    func exportPlayEntries() -> Data? {
        dataPersistenceService.exportPlayEntries()
    }
    
    func importPlayEntries(from data: Data) -> Bool {
        dataPersistenceService.importPlayEntries(from: data)
    }
}

struct User {
    let id: String
    let name: String
    let email: String
}
