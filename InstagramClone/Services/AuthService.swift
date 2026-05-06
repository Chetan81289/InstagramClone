//
//  AuthService.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    
    func login(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }
    
    func signUp(email: String, password: String, username: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        // Save the extra user info to Firestore (the custom model)
        let user = User(username: username, email: email, followers: [], following: [], postsCount: 0)
        try await UserService.shared.createUser(user: user, uid: result.user.uid)
        return result.user.uid
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
}
