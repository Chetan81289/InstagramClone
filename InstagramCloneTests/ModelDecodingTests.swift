//
//  ModelDecodingTests.swift
//  InstagramCloneTests
//
//  Created by Chetan purohit on 06/05/26.
//

import XCTest
@testable import InstagramClone

final class ModelDecodingTests: XCTestCase {

    func testPostDecoding() throws {
        let json = """
        {
            "id": "doc123",
            "ownerUid": "abc123",
            "caption": "Hello world",
            "mediaURLs": ["https://example.com/img.jpg"],
            "timestamp": 1672531200,
            "likes": ["user1", "user2"],
            "commentsCount": 3
        }
        """.data(using: .utf8)!
        let post = try JSONDecoder().decode(Post.self, from: json)
        XCTAssertEqual(post.id, "doc123")  // now the id is decoded
        XCTAssertEqual(post.ownerUid, "abc123")
        XCTAssertEqual(post.likes, ["user1", "user2"])
        XCTAssertEqual(post.commentsCount, 3)
    }
    
    func testUserDecoding() throws {
        let json = """
        {
            "id": "uid123",
            "username": "chetan",
            "email": "test@test.com",
            "profileImageURL": null,
            "bio": "iOS dev",
            "followers": [],
            "following": []
        }
        """.data(using: .utf8)!
        let user = try JSONDecoder().decode(User.self, from: json)
        XCTAssertEqual(user.username, "chetan")
        XCTAssertEqual(user.bio, "iOS dev")
    }

    func testStoryDecoding() throws {
        let json = """
        {
            "ownerUid": "user1",
            "mediaURLs": ["url1", "url2"],
            "timestamp": 1672531200,
            "isSeenBy": ["viewer1"]
        }
        """.data(using: .utf8)!
        let story = try JSONDecoder().decode(Story.self, from: json)
        XCTAssertEqual(story.mediaURLs.count, 2)
        XCTAssertTrue(story.isSeenBy.contains("viewer1"))
    }
}
