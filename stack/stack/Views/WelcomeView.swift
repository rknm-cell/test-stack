import SwiftUI
import Combine
import Foundation
import AuthenticationServices

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
            
            // Sign In Options
            VStack(spacing: 16) {
                // Apple Sign In Button
                SignInWithAppleButton(
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                let userID = appleIDCredential.user
                                let email = appleIDCredential.email
                                let fullName = appleIDCredential.fullName
                                
                                let name = [fullName?.givenName, fullName?.familyName]
                                    .compactMap { $0 }
                                    .joined(separator: " ")
                                
                                let user = User(
                                    id: userID,
                                    name: name.isEmpty ? "Apple User" : name,
                                    email: email ?? "no-email@privaterelay.appleid.com"
                                )
                                
                                appState.currentUser = user
                                appState.isAuthenticated = true
                            }
                        case .failure(let error):
                            appState.errorMessage = "Sign in failed: \(error.localizedDescription)"
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(8)
                
                // Mock Sign In Button (for development)
                Button(action: {
                    appState.signInWithMock()
                }) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("Continue as Guest (Development)")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            // Error message
            if let errorMessage = appState.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
