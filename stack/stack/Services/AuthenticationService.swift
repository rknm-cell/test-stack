//
//  AuthenticationService.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation
import AuthenticationServices
import Combine

// MARK: - Authentication Service
class AuthenticationService: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    private func checkAuthenticationStatus() {
        // Check if user is already signed in (you could store this in Keychain)
        // For now, we'll start with no authentication
        isAuthenticated = false
        currentUser = nil
    }
    
    // MARK: - Apple Sign In
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - Sign Out
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        errorMessage = nil
        
        // Clear any stored authentication data
        // In a real app, you'd clear Keychain data here
    }
    
    // MARK: - Mock Sign In (for development)
    func signInWithMock() {
        let mockUser = User(
            id: "user_123",
            name: "Play Enthusiast",
            email: "user@example.com"
        )
        isAuthenticated = true
        currentUser = mockUser
        errorMessage = nil
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            
            // Create user from Apple ID credential
            let name = [fullName?.givenName, fullName?.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            
            let user = User(
                id: userID,
                name: name.isEmpty ? "Apple User" : name,
                email: email ?? "no-email@privaterelay.appleid.com"
            )
            
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.currentUser = user
                self.errorMessage = nil
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Sign in failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthenticationService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Return the main window
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}