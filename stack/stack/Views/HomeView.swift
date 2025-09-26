//
//  HomeView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingPlayLog = false
    @State private var showingDiscoveryFeed = false
    @State private var showingPlayHistory = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                if let user = appState.currentUser{
                    Text("Welcome, \(user.name)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if appState.hasLoggedPlay {
                        VStack(spacing: 12) {
                            // Play Statistics
                            HStack(spacing: 20) {
                                VStack {
                                    Text("\(appState.totalPlayEntries)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Text("Total Logs")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                VStack {
                                    Text("\(appState.currentStreak)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.orange)
                                    Text("Day Streak")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                VStack {
                                    Text("\(appState.playEntriesByCategory.count)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Text("Categories")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            if appState.totalPlayEntries == 1 {
                                Text("🎉 Discovery feed unlocked!")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("Ready to log your first play moment?")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Welcome to NoomaStack!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        showingPlayLog = true
                    }){
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text(appState.hasLoggedPlay ? "Log Another Play Moment" : "Log Your Play")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    // Show discovery feed button if user has logged play
                    if appState.hasLoggedPlay {
                        Button(action: {
                            showingDiscoveryFeed = true
                        }){
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Discover Play")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            showingPlayHistory = true
                        }){
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("View Play History")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    appState.signOut()
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Home")
            .sheet(isPresented: $showingPlayLog) {
                PlayLogView()
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showingDiscoveryFeed) {
                DiscoveryFeedView()
            }
            .sheet(isPresented: $showingPlayHistory) {
                PlayHistoryView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
