//
//  Post.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseFirestore

struct Post: Identifiable, Codable, Equatable {
    var id: String?
    var ownerUid: String
    var caption: String
    var mediaURLs: [String]   // supports multiple images/videos
    var timestamp: Date = Date()
    var likes: [String] = []      // user IDs
    var commentsCount: Int
}
