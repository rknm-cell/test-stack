//
//  ContentView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI
import Combine
import Foundation

struct ContentView: View {
    @StateObject private var appState = AppState()
    var body: some View {
        if appState.isAuthenticated {
            HomeView()
                .environmentObject(appState)
        } else {
            WelcomeView()
                .environmentObject(appState)
        }
        
    }
}

#Preview {
    ContentView()
}
