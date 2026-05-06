//
//  User.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable, Equatable {
    var id: String?
    var username: String
    var email: String
    var profileImageURL: String?
    var bio: String?
    var followers: [String]   // user IDs
    var following: [String]   // user IDs
    var postsCount: Int?
}
