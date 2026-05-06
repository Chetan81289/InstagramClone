//
//  PostCell.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI

struct PostCell: View {
    let post: Post
    @State private var currentMediaIndex = 0
    @State private var isLiked = false // check if user liked
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header: profile pic + username
            HStack {
                Image(systemName: "person.circle") // replace with actual image
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                Text(post.ownerUid)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "ellipsis")
            }
            .padding(.horizontal)
            
            // Media carousel (swipe through images/videos)
            TabView(selection: $currentMediaIndex) {
                ForEach(post.mediaURLs.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: post.mediaURLs[index])) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .tag(index)
                }
            }
            .frame(height: 400)
            .tabViewStyle(.page)
            
            // Action buttons (like, comment, share)
            HStack(spacing: 16) {
                Button { /* like/unlike */ } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .primary)
                }
                Button { /* comment */ } label: {
                    Image(systemName: "bubble.right")
                }
                Button { /* share */ } label: {
                    Image(systemName: "paperplane")
                }
                Spacer()
            }
            .padding(.horizontal)
            
            // Likes count
            Text("\(post.likes.count) likes")
                .font(.footnote).fontWeight(.semibold)
                .padding(.horizontal)
            
            // Caption
            Text("**\(post.ownerUid)** \(post.caption)")
                .font(.caption)
                .padding(.horizontal)
            
            // Comments count
            Text("View all \(post.commentsCount) comments")
                .font(.footnote).foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 4)
        }
    }
}
