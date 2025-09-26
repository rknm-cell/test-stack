import SwiftUI
import Combine
import Foundation

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 30) {
            // App Logo/Icon
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            // App Title
            Text("NoomaStack")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Subtitle
            Text("Log your moments of play")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Description
            Text("Discover how others are playing and find inspiration for your next creative adventure")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Sign In Button
            Button(action: {
                // Create a mock user for learning purposes
                let mockUser = User(
                    id: "user_123",
                    name: "Play Enthusiast",
                    email: "user@noomastack.com"
                )
                appState.currentUser = mockUser
                appState.isAuthenticated = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Error message
            if let errorMessage = appState.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
