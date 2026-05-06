//
//  StoryViewModel.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseAuth
import Combine

@MainActor
final class StoryViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var groupedStories: [String: [Story]] = [:]   // grouped by ownerUid
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    private let storyService: StoryServiceProtocol
    private let userService: UserServiceProtocol
    
    // 🔌 Dependency injection – defaults to real services
    init(storyService: StoryServiceProtocol = StoryService(),
         userService: UserServiceProtocol = UserService()) {
        self.storyService = storyService
        self.userService = userService
    }
    
    func fetchStories() async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let currentUser = try await UserService.shared.fetchUser(uid: currentUid)
            let followingUids = currentUser.following
            
            guard !followingUids.isEmpty else {
                self.stories = []
                self.groupedStories = [:]
                return
            }
            
            let fetched = try await storyService.fetchActiveStories(for: followingUids)
            self.stories = fetched
            self.groupedStories = Dictionary(grouping: fetched, by: { $0.ownerUid })
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchStories(for followingUids: [String]) async {
        guard !followingUids.isEmpty else {
            self.stories = []
            self.groupedStories = [:]
            return
        }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetched = try await storyService.fetchActiveStories(for: followingUids)
            self.stories = fetched
            self.groupedStories = Dictionary(grouping: fetched, by: \.ownerUid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Create a new story (images are passed from ImagePicker)
    func createStory(images: [UIImage]) async {
        guard let ownerUid = Auth.auth().currentUser?.uid else { return }
        do {
            try await storyService.createStory(ownerUid: ownerUid, images: images)
            // Refresh stories after posting
            await fetchStories()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Mark a story as seen by the current user
    func markSeen(_ story: Story) async {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let storyId = story.id else { return }
        do {
            try await storyService.markSeen(storyId: storyId, currentUid: currentUid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
