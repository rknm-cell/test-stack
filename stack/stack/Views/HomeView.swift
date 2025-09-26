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
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                if let user = appState.currentUser{
                    Text("Welcome, \(user.name)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if appState.hasLoggedPlay {
                        VStack(spacing: 8) {
                            Text("🎉 Great! You've logged \(appState.totalPlayEntries) play moment\(appState.totalPlayEntries == 1 ? "" : "s")")
                                .font(.title2)
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                            
                            if appState.totalPlayEntries == 1 {
                                Text("Discovery feed unlocked!")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
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
                .padding(.horizontal)
                
                // Show discovery feed button if user has logged play
                if appState.hasLoggedPlay {
                    Button(action: {
                        // TODO: Navigate to discovery feed
                        print("Navigate to discovery feed")
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
                    .padding(.horizontal)
                }
                
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
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
