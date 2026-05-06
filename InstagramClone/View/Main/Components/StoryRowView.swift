//
//  StoryRowView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI

struct StoryRowView: View {
    // The stories from the view model – we'll group them by user
    let stories: [Story]
    var onMyStoryTap: (() -> Void)?   // optional closure for "Your Story"
    // Group stories by ownerUid (each user appears once with their first story’s media)
    private var groupedStories: [String: [Story]] {
        Dictionary(grouping: stories, by: { $0.ownerUid })
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // "My Story" button (optional, if you want to allow adding your own)
                MyStoryButton(action: onMyStoryTap)
                // Each unique user who has an active story
                ForEach(groupedStories.keys.sorted(), id: \.self) { ownerUid in
                    if let userStories = groupedStories[ownerUid],
                       let firstStory = userStories.first {
                        StoryCell(story: firstStory, allStories: userStories)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - My Story Button (plus icon with gradient ring)
struct MyStoryButton: View {
    var action: (() -> Void)?
    var body: some View {
        VStack(spacing: 4) {
            Button{
                action?()
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 68, height: 68)
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray.opacity(0.4))
                        .clipShape(Circle())
                    
                    // Plus icon at bottom right
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 24, y: 24)
                }
            }
            Text("Your story")
                .font(.caption2)
                .lineLimit(1)
        }
    }
}

// MARK: - Individual Story Cell
struct StoryCell: View {
    let story: Story
    let allStories: [Story]
    @State private var showViewer = false
    
    var body: some View {
        VStack(spacing: 4) {
            Button {
                showViewer = true
            } label: {
                ZStack {
                    // Gradient ring (Instagram’s signature story ring)
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.purple, .pink, .orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 70, height: 70)
                    
                    // User’s avatar (use first story’s first image, or placeholder)
                    if let urlString = story.mediaURLs.first,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 62, height: 62)
                                    .clipShape(Circle())
                            } else {
                                placeholderAvatar
                            }
                        }
                    } else {
                        placeholderAvatar
                    }
                }
            }
            
            // Username truncated
            Text(story.ownerUid)   // Replace with actual username from a UserService fetch
                .font(.caption2)
                .lineLimit(1)
                .frame(width: 70)
        }
        .fullScreenCover(isPresented: $showViewer) {
            StoryViewer(stories: allStories)
        }
    }
    
    private var placeholderAvatar: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 62, height: 62)
            .overlay(Text("😊").font(.title))
    }
}

// MARK: - Preview
struct StoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        StoryRowView(stories: [])
    }
}
