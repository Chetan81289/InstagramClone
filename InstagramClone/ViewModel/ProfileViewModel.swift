//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseAuth
import Combine
import FirebaseFirestore


@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?                     // custom User model
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var isCurrentUser = false
    @Published var errorMessage: String? = nil
   // private let userService = UserService.shared
   // private let postService = PostService.shared
    private let storyService = StoryService.shared
    
    private let userService: UserServiceProtocol
    private let postService: PostServiceProtocol
    
    init(userService: UserServiceProtocol = UserService(),
         postService: PostServiceProtocol = PostService()) {
        self.userService = userService
        self.postService = postService
    }
    
    /// Load the profile for a given user ID (or current user if nil)
    func loadProfile(uid: String? = nil) async {
        guard let uid = uid, !uid.isEmpty else {
            // No valid user id – silently return (no error)
            return
        }
        let targetUid = uid
        guard !targetUid.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Fetch user info
            self.user = try await userService.fetchUser(uid: targetUid)
            // Determine if this is the logged‑in user
            self.isCurrentUser = (targetUid == Auth.auth().currentUser?.uid)
            
            // Fetch user’s posts (even if empty, no error)
            let snapshot = try? await Firestore.firestore().collection("posts")
                .whereField("ownerUid", isEqualTo: uid)
                .order(by: "timestamp", descending: true)
                .getDocuments()
            self.posts = snapshot?.documents.compactMap { try? $0.data(as: Post.self) } ?? []
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Fetch posts belonging to a specific user, ordered by time
    private func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await Firestore.firestore().collection("posts")
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }
    
    /// Follow / unfollow the currently viewed user
    func toggleFollow() async {
        guard let targetUser = user,
              let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let isFollowing = targetUser.followers.contains(currentUid)
        
        do {
            if isFollowing {
                try await userService.unfollow(uid: targetUser.id ?? "", currentUid: currentUid)
            } else {
                try await userService.follow(uid: targetUser.id ?? "", currentUid: currentUid)
            }
            // Reload to reflect new follower counts
            await loadProfile(uid: targetUser.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Update bio (example of edit functionality)
    func updateBio(_ newBio: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            try await Firestore.firestore().collection("users").document(uid).updateData([
                "bio": newBio
            ])
            // Update local model
            self.user?.bio = newBio
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
