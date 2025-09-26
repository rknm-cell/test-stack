//
//  AppState.swift
//  stack
//
//  Created by rknm on 9/24/25.
//

import Foundation

class AppState: ObservableObject{
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    func signIn(){
        isAuthenticated = true
    }
    func signOut(){
        isAuthenticated = false
        currentUser = nil
    }
}

struct User {
    let id: String
    let name: String
    let email: String
}
