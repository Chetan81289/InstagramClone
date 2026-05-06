//
//  AuthViewModel.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseAuth
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    // ✅ Store only the user ID – easy to mock
    @Published var userSession: String? = Auth.auth().currentUser?.uid
    @Published var errorMessage: String? = nil
    @Published var isLoading = false

    private let authService: AuthServiceProtocol

    // Dependency injection for testing
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let uid = try await authService.login(email: email, password: password)
                self.userSession = uid
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func signUp(email: String, password: String, username: String) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let uid = try await authService.signUp(email: email, password: password, username: username)
                self.userSession = uid
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func logout() {
        try? authService.logout()
        userSession = nil
    }
}

//import SwiftUI
//import FirebaseAuth
//import Combine
//
//@MainActor
//class AuthViewModel: ObservableObject {
//    // Stores the Firebase Authentication user – nil means logged out
//    @Published var userSession: FirebaseAuth.User? = Auth.auth().currentUser
//    @Published var errorMessage: String? = nil   
//    @Published var isLoading = false
//  
//    
//    func login(email: String, password: String) {
//        isLoading = true
//        print("✅ isLoading set to true")
//        errorMessage = nil
//        Task {
//            try? await Task.sleep(for: .seconds(2))
//            do {
//                let firebaseUser = try await AuthService.shared.login(email: email, password: password)
//                self.userSession = firebaseUser
//                print("✅ Login success, setting isLoading = false")
//            } catch {
//                errorMessage = error.localizedDescription
//                print("❌ Login error: \(error.localizedDescription)")
//            }
//        }
//        print("✅ isLoading now false")
//        isLoading = false
//    }
//
//    func signUp(email: String, password: String, username: String) {
//        isLoading = true
//        Task {
//            do {
//                let firebaseUser = try await AuthService.shared.signUp(email: email, password: password, username: username)
//                self.userSession = firebaseUser
//            } catch {
//                errorMessage = error.localizedDescription
//            }
//        }
//        isLoading = false
//    }
//
//    func logout() {
//        try? AuthService.shared.logout()
//        userSession = nil
//    }
//}
