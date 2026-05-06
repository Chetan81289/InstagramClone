//
//  SearchView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var selectedUser: User?        // for navigation
    @State private var navigateToProfile = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar (native)
                TextField("Search users…", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .onSubmit {
                        Task { await viewModel.search() }
                    }
                    .onChange(of: viewModel.searchText) { newValue in
                        // Optional: auto‑search after a short pause (debounce)
                        Task {
                            try? await Task.sleep(for: .milliseconds(300))
                            if viewModel.searchText == newValue {
                                await viewModel.search()
                            }
                        }
                    }

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.users.isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        viewModel.searchText.isEmpty
                            ? "Search for users"
                            : "No users found",
                        systemImage: "person.slash"
                    )
                    Spacer()
                } else {
                    // Results list
                    List(viewModel.users) { user in
                        Button {
                            selectedUser = user
                            navigateToProfile = true
                        } label: {
                            HStack(spacing: 12) {
                                // Avatar (placeholder)
                                if let url = user.profileImageURL, let imageURL = URL(string: url) {
                                    AsyncImage(url: imageURL) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Circle().fill(Color.gray.opacity(0.3))
                                    }
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 44, height: 44)
                                        .overlay(Text("😊"))
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(user.username)
                                        .fontWeight(.semibold)
                                    Text(user.email)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
        // Navigate to the selected user’s profile
        .navigationDestination(isPresented: $navigateToProfile) {
            if let user = selectedUser {
                ProfileView(uid: user.id ?? "")   // We'll create a version of ProfileView that accepts a uid
            }
        }
    }
}
