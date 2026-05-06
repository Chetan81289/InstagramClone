//
//  StoryService.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class StoryService {
    static let shared = StoryService()
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()

    // MARK: - Upload helpers

    /// Upload multiple media items (images/videos) and return their download URLs
    private func uploadMedia(_ images: [UIImage]) async throws -> [String] {
        var urls: [String] = []
        for (index, image) in images.enumerated() {
            guard let data = image.jpegData(compressionQuality: 0.8) else { continue }
            let ref = storage.child("stories/\(UUID().uuidString)_\(index).jpg")
            let _ = try await ref.putDataAsync(data)
            let url = try await ref.downloadURL()
            urls.append(url.absoluteString)
        }
        return urls
    }

    /// Create a new story document after uploading media.
    /// - Parameters:
    ///   - ownerUid: The UID of the user posting the story.
    ///   - images: Array of UIImages to be uploaded.
    func createStory(ownerUid: String, images: [UIImage]) async throws {
        let urls = try await uploadMedia(images)
        let story = Story(ownerUid: ownerUid, mediaURLs: urls, isSeenBy: [])
        try db.collection("stories").addDocument(from: story)
    }

    // MARK: - Fetching

    /// Fetch all active stories (within last 24 hours) from a set of user IDs.
    /// - Parameter followingUids: The UIDs the current user is following.
    /// - Returns: Array of Story objects, newest first.
    func fetchActiveStories(for followingUids: [String]) async throws -> [Story] {
        guard !followingUids.isEmpty else { return [] }

        let twentyFourHoursAgo = Timestamp(date: Date().addingTimeInterval(-86400))
        let snapshot = try await db.collection("stories")
            .whereField("ownerUid", in: followingUids)
            .whereField("timestamp", isGreaterThanOrEqualTo: twentyFourHoursAgo)
            .order(by: "timestamp", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Story.self) }
    }

    // MARK: - Interaction

    /// Mark a story as seen by a given user (no duplicates).
    /// - Parameters:
    ///   - storyId: The document ID of the story.
    ///   - currentUid: The UID of the viewing user.
    func markSeen(storyId: String, currentUid: String) async throws {
        try await db.collection("stories").document(storyId).updateData([
            "isSeenBy": FieldValue.arrayUnion([currentUid])
        ])
    }

    // MARK: - Cleanup

    /// Delete all stories older than 24 hours (should be run periodically).
    func deleteExpiredStories() async throws {
        let twentyFourHoursAgo = Timestamp(date: Date().addingTimeInterval(-86400))
        let snapshot = try await db.collection("stories")
            .whereField("timestamp", isLessThan: twentyFourHoursAgo)
            .getDocuments()

        for doc in snapshot.documents {
            try await doc.reference.delete()
        }
    }
}
