//
//  EditProfileView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var profileVM = ProfileViewModel()

    // Local state for the form
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var profileImageURL: String? = nil   // existing URL if any
    @State private var selectedImage: UIImage?           // new image from picker
    @State private var showImagePicker = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                // Profile picture section
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else if let urlStr = profileImageURL,
                                      let url = URL(string: urlStr) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable().scaledToFill()
                                    } else {
                                        placeholderAvatar
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                placeholderAvatar
                            }

                            Button("Change Profile Photo") {
                                showImagePicker = true
                            }
                            .font(.footnote)
                            .padding(.top, 8)
                        }
                        Spacer()
                    }
                }

                // Name & Bio
                Section {
                    TextField("Username", text: $username)
                        .textContentType(.username)
                        .autocapitalization(.none)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...5)
                }

                // Save button
                Section {
                    Button("Save") {
                        Task { await saveChanges() }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(username.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                Task {
                    await profileVM.loadProfile(uid: Auth.auth().currentUser?.uid)
                    if let user = profileVM.user {
                        username = user.username
                        bio = user.bio ?? ""
                        profileImageURL = user.profileImageURL
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                // We'll reuse the existing ImagePicker
                ImagePicker(images: .constant([]))  // For now, single image selection
                // Note: You may want to create a single-image variant or use this array to get the first image.
            }
        }
    }

    private func saveChanges() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Update username and bio in Firestore
        do {
            try await Firestore.firestore().collection("users").document(uid).updateData([
                "username": username,
                "bio": bio
            ])

            // If a new image was selected, upload it and update the URL
            if let image = selectedImage {
                // TODO: Upload to Storage and get URL, then update Firestore field "profileImageURL"
                // For now, we'll just update the local user model
                // let url = try await uploadProfileImage(image, uid: uid)
                // try await Firestore.firestore().collection("users").document(uid).updateData(["profileImageURL": url])
            }

            dismiss()
        } catch {
            print("Failed to save profile: \(error)")
        }
    }

    private var placeholderAvatar: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 100, height: 100)
            .overlay(Text("😊").font(.system(size: 40)))
    }
}
