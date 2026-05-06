//
//  NotificationsView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI

struct NotificationsView: View {
    // For now, notifications are static. Later you can replace this with a real ViewModel.
    @State private var notifications: [NotificationItem] = []

    var body: some View {
        NavigationStack {
            Group {
                if notifications.isEmpty {
                    ContentUnavailableView(
                        "No New Notifications",
                        systemImage: "heart.text.square",
                        description: Text("When someone likes your photo or follows you, you'll see it here.")
                    )
                } else {
                    List(notifications) { notification in
                        NotificationRow(notification: notification)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Notification Model (temporary)
struct NotificationItem: Identifiable {
    let id = UUID()
    let username: String
    let action: String   // e.g., "liked your photo", "started following you"
    let postImageURL: String?   // optional thumbnail
    let timeAgo: String
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: NotificationItem

    var body: some View {
        HStack(spacing: 12) {
            // Profile pic placeholder
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay(Text("😊"))

            VStack(alignment: .leading, spacing: 2) {
                Text("**\(notification.username)** \(notification.action)")
                    .font(.subheadline)
                Text(notification.timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if let url = notification.postImageURL, let imageURL = URL(string: url) {
                AsyncImage(url: imageURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
