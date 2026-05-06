//
//  MockServices.swift
//  InstagramCloneTests
//
//  Created by Chetan purohit on 06/05/26.
//

import Foundation
import XCTest
@testable import InstagramClone

final class MockAuthService: AuthServiceProtocol {
    var shouldThrow = false
    var currentUid = "test_uid_123"

    func login(email: String, password: String) async throws -> String {
        if shouldThrow { throw NSError(domain: "mock", code: 401) }
        return currentUid
    }

    func signUp(email: String, password: String, username: String) async throws -> String {
        if shouldThrow { throw NSError(domain: "mock", code: 409) }
        return currentUid
    }

    func logout() throws {
        // nothing needed
    }
}

//// We'll use protocol for testability
//protocol AuthServiceProtocol {
//    func login(email: String, password: String) async throws -> FirebaseAuth.User
//    func signUp(email: String, password: String, username: String) async throws -> FirebaseAuth.User
//    func logout() throws
//}
// Conform the real AuthService to this protocol (add to AuthService.swift)

// MARK: - Mock User Service
final class MockUserService: UserServiceProtocol {
    var users: [String: InstagramClone.User] = [:]
    var shouldThrow = false
    var followCalled = false
    var unfollowCalled = false

    func createUser(user: InstagramClone.User, uid: String) async throws {
        if shouldThrow { throw NSError(domain: "mock", code: 500) }
        users[uid] = user
    }

    func fetchUser(uid: String) async throws -> InstagramClone.User {
        if shouldThrow { throw NSError(domain: "mock", code: 404) }
        guard let user = users[uid] else { throw NSError(domain: "mock", code: 404) }
        return user
    }

    func searchUsers(query: String) async throws -> [InstagramClone.User] {
        if shouldThrow { throw NSError(domain: "mock", code: 500) }
        return users.values.filter { $0.username.lowercased().contains(query.lowercased()) }
    }

    func follow(uid: String, currentUid: String) async throws {
        if shouldThrow { throw NSError(domain: "mock", code: 500) }
        followCalled = true
        if var user = users[uid] {
            if !user.followers.contains(currentUid) {
                user.followers.append(currentUid)
                users[uid] = user
            }
        }
    }

    func unfollow(uid: String, currentUid: String) async throws {
        if shouldThrow { throw NSError(domain: "mock", code: 500) }
        unfollowCalled = true
        if var user = users[uid] {
            user.followers.removeAll { $0 == currentUid }
            users[uid] = user
        }
    }
}

