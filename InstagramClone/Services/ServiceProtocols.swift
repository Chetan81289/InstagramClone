//
//  ServiceProtocols.swift
//  InstagramClone
//
//  Created by Chetan purohit on 06/05/26.
//

import Foundation
import FirebaseAuth
import UIKit

// MARK: - Auth
protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> String
    func signUp(email: String, password: String, username: String) async throws -> String
    func logout() throws
}

extension AuthService: AuthServiceProtocol {}   

// MARK: - User
protocol UserServiceProtocol {
    func createUser(user: InstagramClone.User, uid: String) async throws
    func fetchUser(uid: String) async throws -> InstagramClone.User
    func searchUsers(query: String) async throws -> [InstagramClone.User]
    func follow(uid: String, currentUid: String) async throws
    func unfollow(uid: String, currentUid: String) async throws
}
//protocol UserServiceProtocol {
//    func createUser(user: User, uid: String) async throws
//    func fetchUser(uid: String) async throws -> User
//    func searchUsers(query: String) async throws -> [User]
//    func follow(uid: String, currentUid: String) async throws
//    func unfollow(uid: String, currentUid: String) async throws
//}

extension UserService: UserServiceProtocol {}   

// MARK: - Post
protocol PostServiceProtocol {
    func createPost(caption: String, images: [UIImage], ownerUid: String) async throws
    func fetchFeedPosts(uids: [String]) async throws -> [Post]
    func likePost(postId: String, currentUid: String) async throws
    func unlikePost(postId: String, currentUid: String) async throws
}

extension PostService: PostServiceProtocol {}   // already conforms

// MARK: - Story
protocol StoryServiceProtocol {
    func createStory(ownerUid: String, images: [UIImage]) async throws
    func fetchActiveStories(for followingUids: [String]) async throws -> [Story]
    func markSeen(storyId: String, currentUid: String) async throws
    func deleteExpiredStories() async throws
}

extension StoryService: StoryServiceProtocol {} // already conforms
