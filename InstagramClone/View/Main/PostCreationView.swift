//
//  PostCreationView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import FirebaseAuth

struct PostCreationView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var caption = ""
    @State private var showImagePicker = false
    @State private var isPosting = false
    @State private var errorMessage: String? = nil

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                // Image selection area
                if selectedImages.isEmpty {
                    Button {
                        showImagePicker = true
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary)
                            Text("Tap to select photos")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Button {
                                showImagePicker = true
                            } label: {
                                Image(systemName: "plus")
                                    .frame(width: 80, height: 80)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Caption field
                TextField("Write a caption...", text: $caption, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Spacer()

                // Post button
                Button(action: post) {
                    if isPosting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Post")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canPost ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(!canPost || isPosting)
                .padding()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $selectedImages, maxSelection: 10)
            }
        }
        .errorAlert(message: $errorMessage)
    }

    private var canPost: Bool {
        !selectedImages.isEmpty && !caption.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func post() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isPosting = true
        Task {
            do {
                try await PostService.shared.createPost(caption: caption, images: selectedImages, ownerUid: uid)
                // Dismiss this view? Since it's a tab, probably navigate to feed or just reset.
                // For simplicity, reset form and show success message, or dismiss if it's a modal.
                // Currently it's a tab, so we can reset the form.
                selectedImages = []
                caption = ""
                isPosting = false
                // Optionally switch to feed tab, but that's complex. We'll just reset.
            } catch {
                errorMessage = error.localizedDescription
                isPosting = false
            }
        }
    }
}
