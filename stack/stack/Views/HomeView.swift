//
//  HomeView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationView{
            VStack(spacing: 20){
                Text("Welcome to NoomaStack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Ready to log your first play moment?")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
                
                Button(action: {
                    print("Log play tapped!")
                }) {
                    Text("Log your Play")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
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
        }
    }
}
#Preview {
    HomeView()
        .environmentObject(AppState())
}
