//
//  SignUpView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI

struct SignUpView: View {
    // MARK: - State
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        ZStack {
            // Instagram gradient background with dark overlay for better contrast
            LinearGradient(
                colors: [.igPurple, .igPink, .igOrange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .overlay(Color.black.opacity(0.4))

            VStack(spacing: 25) {
                Spacer()

                // Logo / App icon
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)

                Text("Instagram")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .tracking(2)

                Text("Sign up to see photos and videos\nfrom your friends.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                // Input fields with glass effect
                VStack(spacing: 15) {
                    // Username
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Username", text: $username)
                            .foregroundColor(.white)
                            .textContentType(.username)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                    // Email
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Email", text: $email)
                            .foregroundColor(.white)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                    // Password
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.7))
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                            .textContentType(.newPassword)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                    // Confirm Password
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.7))
                        SecureField("Confirm Password", text: $confirmPassword)
                            .foregroundColor(.white)
                            .textContentType(.newPassword)
                            .onChange(of: confirmPassword) { _ in
                                passwordsMatch = password.isEmpty || password == confirmPassword
                            }
                            .onChange(of: password) { _ in
                                passwordsMatch = confirmPassword.isEmpty || password == confirmPassword
                            }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                    // Mismatch warning
                    if !confirmPassword.isEmpty && !passwordsMatch {
                        Text("Passwords don't match")
                            .font(.caption2)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                }

                // Sign Up button with scale animation and loading state
                Button {
                    guard passwordsMatch else { return }
                    authVM.signUp(email: email, password: password, username: username)
                } label: {
                    ZStack {
                        if authVM.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSignUp ? Color.igBlue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!canSignUp || authVM.isLoading)
                .buttonStyle(ScaleButtonStyle())

                Spacer()

                // Link back to Login
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    Button("Log In") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
                .font(.subheadline)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 30)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }

    // MARK: - Validation
    private var canSignUp: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty &&
        !username.trimmingCharacters(in: .whitespaces).isEmpty &&
        !confirmPassword.isEmpty &&
        passwordsMatch
    }
}


// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
                .environmentObject(AuthViewModel())
        }
    }
}
