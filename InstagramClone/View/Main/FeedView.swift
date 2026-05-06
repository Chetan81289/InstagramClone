//
//  FeedView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseAuth

struct FeedView: View {
    @StateObject var feedVM = FeedViewModel()
    @StateObject var storyVM = StoryViewModel()
    @State private var isLoading = true
    @State private var showStoryPicker = false
    @State private var storyImages: [UIImage] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                if feedVM.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
                ScrollView {
                    // Stories row
                    StoryRowView(stories: storyVM.stories){
                        showStoryPicker = true
                    }
                    .padding(.vertical, 8)
                    
                    LazyVStack(spacing: 32) {
                        ForEach(feedVM.posts) { post in
                            PostCell(post: post)
                        }
                    }
                }
            }
            .refreshable { await loadData() }
            .navigationTitle("Instagram")
            .task { await loadData() }
            .sheet(isPresented: $showStoryPicker, content: {
                ImagePicker(images: $storyImages, maxSelection: 2)
            })
            .onChange(of: storyImages){ newImages in
                guard !newImages.isEmpty else { return }
                Task {
                    await storyVM.createStory(images: newImages)
                    storyImages = []          // reset for next time
                    showStoryPicker = false   // dismiss picker
                    await loadData()          // refresh feed (stories will update)
                }
            }
            .errorAlert(message: $feedVM.errorMessage)
        }
    }
    
    private func loadData() async {
        // Assume we have logged in user info
        let currentUser = try? await UserService.shared.fetchUser(uid: Auth.auth().currentUser?.uid ?? "")
        let following = currentUser?.following ?? []
        await feedVM.fetchPosts(for: following)
        await storyVM.fetchStories(for: following)
    }
}
