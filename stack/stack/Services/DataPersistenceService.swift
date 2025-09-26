//
//  DataPersistenceService.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import Combine

// MARK: - Data Persistence Service
class DataPersistenceService: ObservableObject {
    @Published var playEntries: [PlayEntry] = []
    
    private let userDefaults = UserDefaults.standard
    private let playEntriesKey = "saved_play_entries"
    
    init() {
        loadPlayEntries()
    }
    
    // MARK: - Play Entries Management
    func addPlayEntry(_ entry: PlayEntry) {
        playEntries.insert(entry, at: 0) // Add to beginning for newest first
        savePlayEntries()
    }
    
    func deletePlayEntry(withId id: String) {
        playEntries.removeAll { $0.id == id }
        savePlayEntries()
    }
    
    func updatePlayEntry(_ entry: PlayEntry) {
        if let index = playEntries.firstIndex(where: { $0.id == entry.id }) {
            playEntries[index] = entry
            savePlayEntries()
        }
    }
    
    // MARK: - Data Persistence
    private func savePlayEntries() {
        do {
            let data = try JSONEncoder().encode(playEntries)
            userDefaults.set(data, forKey: playEntriesKey)
        } catch {
            print("Failed to save play entries: \(error)")
        }
    }
    
    private func loadPlayEntries() {
        guard let data = userDefaults.data(forKey: playEntriesKey) else {
            playEntries = []
            return
        }
        
        do {
            playEntries = try JSONDecoder().decode([PlayEntry].self, from: data)
        } catch {
            print("Failed to load play entries: \(error)")
            playEntries = []
        }
    }
    
    // MARK: - Data Export/Import
    func exportPlayEntries() -> Data? {
        do {
            return try JSONEncoder().encode(playEntries)
        } catch {
            print("Failed to export play entries: \(error)")
            return nil
        }
    }
    
    func importPlayEntries(from data: Data) -> Bool {
        do {
            let importedEntries = try JSONDecoder().decode([PlayEntry].self, from: data)
            playEntries = importedEntries
            savePlayEntries()
            return true
        } catch {
            print("Failed to import play entries: \(error)")
            return false
        }
    }
    
    // MARK: - Statistics
    var totalPlayEntries: Int {
        playEntries.count
    }
    
    var playEntriesByCategory: [PlayCategory: Int] {
        Dictionary(grouping: playEntries, by: { $0.category })
            .mapValues { $0.count }
    }
    
    var hasLoggedPlay: Bool {
        !playEntries.isEmpty
    }
    
    // MARK: - Streak Calculation
    var currentStreak: Int {
        guard !playEntries.isEmpty else { return 0 }
        
        let sortedEntries = playEntries.sorted { $0.date > $1.date }
        var streak = 0
        var currentDate = Calendar.current.startOfDay(for: Date())
        
        for entry in sortedEntries {
            let entryDate = Calendar.current.startOfDay(for: entry.date)
            let daysDifference = Calendar.current.dateComponents([.day], from: entryDate, to: currentDate).day ?? 0
            
            if daysDifference == streak {
                streak += 1
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if daysDifference > streak {
                break
            }
        }
        
        return streak
    }
}