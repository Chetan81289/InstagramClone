//
//  FirebaseManager.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseCore
import Combine

//struct User: Identifiable, Codable, Equatable {
//    var id: String
//    var username: String
//    var email: String
//    var profileImageURL: String?
//    var followers: [String]
//    var following: [String]
//    var bio: String
//}

//struct Post: Identifiable, Codable, Equatable {
//    var id: String
//    var ownerUid: String
//    var caption: String
//    var imageURLs: [String]
//    var timestamp: Date
//    var likes: Int
//}

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    let auth = Auth.auth()
    let firestore = Firestore.firestore()
    let storage = Storage.storage()

    private init() {
        FirebaseApp.configure()
    }

    // MARK: - Authentication

    func login(email: String, password: String) async throws -> AuthDataResult {
        return try await auth.signIn(withEmail: email, password: password)
    }

    func register(email: String, password: String) async throws -> AuthDataResult {
        return try await auth.createUser(withEmail: email, password: password)
    }

    func signOut() {
        try? auth.signOut()
    }


    func createUserDocument(uid: String, username: String, email: String) async throws {
        let user = User(
            id: uid,
            username: username,
            email: email,
            profileImageURL: nil,
            bio: "",
            followers: [],
            following: []
        )
        try firestore.collection("users").document(uid).setData(from: user)
    }

    func fetchUser(uid: String) async throws -> User? {
        let document = try await firestore.collection("users").document(uid).getDocument()
        guard document.exists else { return nil }
        return try document.data(as: User.self)
    }

    func updateUser(uid: String, data: [String: Any]) async throws {
        try await firestore.collection("users").document(uid).updateData(data)
    }

    // MARK: - Post Helpers

    func createPost(ownerUid: String, caption: String, imageURLs: [String]) async throws {
        let post = Post(ownerUid: ownerUid, caption: caption, mediaURLs: imageURLs, likes: [], commentsCount: 0)
        try firestore.collection("posts").addDocument(from: post)   // auto-generates ID and saves
    }

    func fetchPosts() async throws -> [Post] {
        let query = firestore.collection("posts")
            .order(by: "timestamp", descending: true)
        
        let snapshot = try await query.getDocuments()
        
        // Map each document directly to a Post struct using Codable
        // (FirebaseFirestoreSwift automatically converts Timestamp ↔ Date)
        let posts = snapshot.documents.compactMap { document in
            try? document.data(as: Post.self)
        }
        
        return posts
    }

    // MARK: - Story Helpers (similar)
    // ... you can follow the same dictionary pattern for stories
}

