//
//  PlayLogView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct PlayLogView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PlayLogViewModel
    
    init() {
        // We'll initialize the viewModel in onAppear since we need the appState
        self._viewModel = StateObject(wrappedValue: PlayLogViewModel(appState: AppState()))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("What did you play?")) {
                    TextField(
                        "Describe your play moment...", 
                        text: $viewModel.playDescription, 
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(PlayCategory.allCases, id: \.self) { category in
                            HStack {
                                Text(category.emoji)
                                Text(category.rawValue)
                            }.tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("When?")) {
                    DatePicker(
                        "Date", 
                        selection: $viewModel.playDate, 
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                // Show existing play entries for context
                if !appState.playEntries.isEmpty {
                    Section(header: Text("Your Recent Play Moments")) {
                        ForEach(appState.playEntries.prefix(3)) { entry in
                            VStack(alignment: .leading, spacing: 4) {
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
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .navigationTitle("Log Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.savePlayEntry()
                        dismiss()
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
            }
        }
        .onAppear {
            // Reinitialize viewModel with the current appState
            viewModel.resetForm()
        }
    }
}

#Preview {
    PlayLogView()
        .environmentObject(AppState())
}
