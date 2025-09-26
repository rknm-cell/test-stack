//
//  WelcomeView.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import SwiftUI

struct WelcomeView: View{

    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 30){
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("NoomaStack")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Log moments of play")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text("Discover how others are playing")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            
            Button(action: {
                appState.signIn()
            }) {
                Text("Get started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Button(action: {
                print("Apple Sign in tapped!")
                appState.signIn()
            }) {
                HStack {
                    Image(systemName: "applelogo")
                        .font(.title2)
                    Text("Continue with Apple")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
