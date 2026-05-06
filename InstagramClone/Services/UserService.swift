//
//  UserService.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseFirestore

final class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    func createUser(user: User, uid: String) async throws {
        try db.collection("users").document(uid).setData(from: user)
    }
    
    func fetchUser(uid: String) async throws -> User {
        let doc = try await db.collection("users").document(uid).getDocument()
        return try doc.data(as: User.self)
    }
    
    func searchUsers(query: String) async throws -> [User] {
        let snapshot = try await db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: query)
            .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: User.self) }
    }
    
    func follow(uid: String, currentUid: String) async throws {
        try await db.collection("users").document(uid).updateData([
            "followers": FieldValue.arrayUnion([currentUid])
        ])
        try await db.collection("users").document(currentUid).updateData([
            "following": FieldValue.arrayUnion([uid])
        ])
    }
    
    func unfollow(uid: String, currentUid: String) async throws {
        try await db.collection("users").document(uid).updateData([
            "followers": FieldValue.arrayRemove([currentUid])
        ])
        try await db.collection("users").document(currentUid).updateData([
            "following": FieldValue.arrayRemove([uid])
        ])
    }
}
