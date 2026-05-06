//
//  PostService.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class PostService {
    static let shared = PostService()
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    // Upload multiple media items and return their download URLs
    private func uploadMedia(_ images: [UIImage]) async throws -> [String] {
        var urls = [String]()
        for (index, image) in images.enumerated() {
            guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
            let ref = storage.child("posts/\(UUID().uuidString)_\(index).jpg")
            _ = try await ref.putDataAsync(data)
            let url = try await ref.downloadURL()
            urls.append(url.absoluteString)
        }
        return urls
    }
    
    func createPost(caption: String, images: [UIImage], ownerUid: String) async throws {
        let urls = try await uploadMedia(images)
        let post = Post(ownerUid: ownerUid, caption: caption, mediaURLs: urls, likes: [], commentsCount: 0)
        _ = try db.collection("posts").addDocument(from: post)
        // Increase post count for user
        try await db.collection("users").document(ownerUid).updateData([
            "postsCount": FieldValue.increment(Int64(1))
        ])
    }
    
    func fetchFeedPosts(uids: [String]) async throws -> [Post] {
        guard !uids.isEmpty else { return [] } 
        let snapshot = try await db.collection("posts")
            .whereField("ownerUid", in: uids)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }
    
    func likePost(postId: String, currentUid: String) async throws {
        try await db.collection("posts").document(postId).updateData([
            "likes": FieldValue.arrayUnion([currentUid])
        ])
    }
    
    func unlikePost(postId: String, currentUid: String) async throws {
        try await db.collection("posts").document(postId).updateData([
            "likes": FieldValue.arrayRemove([currentUid])
        ])
    }
}
