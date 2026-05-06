//
//  SearchViewModel.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var users: [User] = []
    @Published var isLoading = false
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService as! UserService
    }
    
    func search() async {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            users = []
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.users = try await userService.searchUsers(query: query)
        } catch {
            print("Search error: \(error)")
            users = []
        }
    }
}
