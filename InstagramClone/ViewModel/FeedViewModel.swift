//
//  FeedViewModel.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import Combine



@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let postService: PostServiceProtocol
    private let userService: UserServiceProtocol

    init(postService: PostServiceProtocol = PostService(),
         userService: UserServiceProtocol = UserService()) {
        self.postService = postService
        self.userService = userService
    }

    func fetchPosts(for userIds: [String]) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            posts = try await postService.fetchFeedPosts(uids: userIds)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
