//
//  Story.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseFirestore

struct Story: Identifiable, Codable, Equatable {
    var id: String?
    var ownerUid: String
    var mediaURLs: [String]   // supports multiple for carousel
    var timestamp: Date = Date()
    var isSeenBy: [String]    // user IDs who have seen it
}
