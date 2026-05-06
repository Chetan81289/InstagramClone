//
//  AuthViewModelTests.swift
//  InstagramCloneTests
//
//  Created by Chetan purohit on 06/05/26.
//

import XCTest
import FirebaseAuth
@testable import InstagramClone

/*final class AuthViewModelTests: XCTestCase {
    var mockAuth: MockAuthService!
    var vm: AuthViewModel!

    @MainActor override func setUp() {
        super.setUp()
        mockAuth = MockAuthService()
        vm = AuthViewModel(authService: mockAuth)   // inject mock
    }

    @MainActor func testLoginSuccess() async {
        mockAuth.shouldThrow = false
        vm.login(email: "a@b.com", password: "123456")
        // wait a bit for the task
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotNil(vm.userSession)
        XCTAssertNil(vm.errorMessage)
    }

    @MainActor func testLoginFailure() async {
        mockAuth.shouldThrow = true
        vm.login(email: "a", password: "")
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNil(vm.userSession)
        XCTAssertNotNil(vm.errorMessage)
    }

    @MainActor func testLogout() {
        // Simulate logged in state
        vm.userSession = "some_test_uid"
        vm.logout()
        XCTAssertNil(vm.userSession)
    }
}*/
