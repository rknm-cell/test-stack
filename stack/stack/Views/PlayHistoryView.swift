//
//  PlayHistoryView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct PlayHistoryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: PlayCategory? = nil
    
    var filteredPlayEntries: [PlayEntry] {
        if let category = selectedCategory {
            return appState.playEntries.filter { $0.category == category }
        }
        return appState.playEntries
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button("All") {
                            selectedCategory = nil
                        }
                        .buttonStyle(CategoryFilterButtonStyle(isSelected: selectedCategory == nil))
                        
                        ForEach(PlayCategory.allCases, id: \.self) { category in
                            Button(category.rawValue) {
                                selectedCategory = category
                            }
                            .buttonStyle(CategoryFilterButtonStyle(isSelected: selectedCategory == category))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Play Entries List
                if filteredPlayEntries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No play entries found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        if selectedCategory != nil {
                            Text("Try selecting a different category")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredPlayEntries) { entry in
                            PlayEntryRow(entry: entry) {
                                appState.deletePlayEntry(withId: entry.id)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Play History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !appState.playEntries.isEmpty {
                        Menu {
                            Button("Export Data") {
                                // TODO: Implement data export
                                print("Export data")
                            }
                            Button("Clear All", role: .destructive) {
                                // TODO: Implement clear all
                                print("Clear all entries")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
    }
}

struct PlayEntryRow: View {
    let entry: PlayEntry
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.displayCategory)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(entry.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(entry.description)
                .font(.body)
                .lineLimit(3)
            
            HStack {
                Spacer()
                Button("Delete") {
                    onDelete()
                }
                .font(.caption)
                .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CategoryFilterButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    PlayHistoryView()
        .environmentObject(AppState())
}

