//
//  StoryViewer.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import Combine

struct StoryViewer: View {
    let stories: [Story]          // stories from a single user, shown sequentially
    @State private var currentIndex = 0
    @State private var progress: CGFloat = 0
    @Environment(\.dismiss) var dismiss

    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Media display (single image per story for simplicity)
            if let url = URL(string: stories[currentIndex].mediaURLs.first ?? "") {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else {
                        Color.black
                    }
                }
            }

            // Progress bars (one per story)
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    ForEach(0..<stories.count, id: \.self) { index in
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                if index < currentIndex {
                                    Rectangle().fill(Color.white)
                                } else if index == currentIndex {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: geo.size.width * progress)
                                }
                            }
                        }
                        .frame(height: 3)
                        .cornerRadius(1.5)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 50)    // safe area top
            }

            // User info & close button
            HStack {
                // Profile pic placeholder + username
                Circle()
                    .fill(Color.gray)
                    .frame(width: 36, height: 36)
                Text(stories[currentIndex].ownerUid)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)

            // Tap areas to advance / go back
            HStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { goToPrevious() }
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { goToNext() }
            }
        }
        .background(Color.black)
        .onReceive(timer) { _ in
            if progress >= 1.0 {
                goToNext()
            } else {
                progress += 0.05 / 5.0   // 5 seconds per story
            }
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismiss()
                    }
                }
        )
    }

    private func goToNext() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            progress = 0
        } else {
            dismiss()
        }
    }

    private func goToPrevious() {
        if currentIndex > 0 {
            currentIndex -= 1
            progress = 0
        }
    }
}
