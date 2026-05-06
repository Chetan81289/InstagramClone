//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    let uid: String
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel

    init(uid: String) {
        self.uid = uid
        _profileVM = StateObject(wrappedValue: ProfileViewModel())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if profileVM.isLoading {
                    ProgressView()
                }
                ScrollView {
                    if profileVM.isLoading {
                        ProgressView()
                            .padding(.top, 100)
                    } else if let user = profileVM.user {
                        VStack(spacing: 16) {
                            HStack(alignment: .top) {
                                Circle()
                                    .fill(LinearGradient(colors: [.purple, .pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 80, height: 80)
                                    .overlay(Text("😊").font(.largeTitle))

                                Spacer()

                                StatCell(number: user.postsCount ?? 0, label: "Posts")
                                StatCell(number: user.followers.count, label: "Followers")
                                StatCell(number: user.following.count, label: "Following")
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.username)
                                    .fontWeight(.bold)
                                if let bio = user.bio, !bio.isEmpty {
                                    Text(bio)
                                        .font(.caption)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                            if profileVM.isCurrentUser {
                                NavigationLink("Edit Profile") {
                                    EditProfileView()
                                }
                                .buttonStyle(.bordered)
                                .padding(.horizontal)
                            } else {
                                Button {
                                    Task { await profileVM.toggleFollow() }
                                } label: {
                                    Text(profileVM.user?.followers.contains(Auth.auth().currentUser?.uid ?? "") ?? false ? "Following" : "Follow")
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal)
                            }

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                                ForEach(profileVM.posts) { post in
                                    if let urlString = post.mediaURLs.first, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                        }
                                        .aspectRatio(1, contentMode: .fill)
                                        .clipped()
                                    } else {
                                        Color.gray.opacity(0.3)
                                            .aspectRatio(1, contentMode: .fill)
                                    }
                                }
                            }
                        }
                    } else {
                        ContentUnavailableView("User not found", systemImage: "person.slash")
                            .padding(.top, 100)
                    }
                }
            }
            // ✅ Fixed alert binding
            .errorAlert(message: $profileVM.errorMessage)
            .navigationTitle(profileVM.user?.username ?? "Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if profileVM.isCurrentUser {
                        Button("Logout") {
                            authVM.logout()
                        }
                    }
                }
            }
        }
        .task {
            await profileVM.loadProfile(uid: uid)
        }
        .onChange(of: uid) { newUid in
            Task { await profileVM.loadProfile(uid: newUid) }
        }
    }
}
