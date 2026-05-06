//
//  FeedViewModelTests.swift
//  InstagramCloneTests
//
//  Created by Chetan purohit on 06/05/26.
//

import XCTest
@testable import InstagramClone



/*final class FeedViewModelTests: XCTestCase {
    var mockPost: MockPostService!
    var mockUser: MockUserService!
    var vm: FeedViewModel!

    @MainActor override func setUp() {
        super.setUp()
        mockPost = MockPostService()
        mockUser = MockUserService()
        vm = FeedViewModel(postService: mockPost, userService: mockUser)
    }

    @MainActor func testFetchPostsEmpty() async {
        // No following → should return empty posts
        await vm.fetchPosts(for: [])
        XCTAssertTrue(vm.posts.isEmpty)
    }

    @MainActor func testFetchPostsWithData() async {
        // Preload a post into mock
        mockPost.posts = [Post(ownerUid: "uid1", caption: "A", mediaURLs: [], likes: [], commentsCount: 0)]
        await vm.fetchPosts(for: ["uid1"])
        XCTAssertEqual(vm.posts.count, 1)
    }

    @MainActor func testFetchPostsError() async {
        mockPost.shouldThrow = true
        await vm.fetchPosts(for: ["uid1"])
        XCTAssertEqual(vm.posts.count, 0)   // error handled, posts empty
        // Optionally check errorMessage if the ViewModel sets one
    }
}*/
