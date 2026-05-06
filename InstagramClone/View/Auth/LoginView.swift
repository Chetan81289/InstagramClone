//
//  LoginView.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingLoading = false   // ✅ local state for overlay

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.igPurple, .igPink, .igOrange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .overlay(Color.black.opacity(0.4))

            // Login form
            VStack(spacing: 25) {
                Spacer()
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                Text("Instagram")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .tracking(2)
                                // Text fields with glass effect
                                VStack(spacing: 15) {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.white.opacity(0.7))
                                        TextField("Email", text: $email)
                                            .foregroundColor(.white)
                                            .keyboardType(.emailAddress)
                                            .autocapitalization(.none)
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.white.opacity(0.7))
                                        SecureField("Password", text: $password)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                }
                Button {
                    isShowingLoading = true   // ✅ local state triggers overlay instantly
                    authVM.login(email: email, password: password)
                } label: {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canLogin ? Color.igBlue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!canLogin || isShowingLoading)

                NavigationLink { SignUpView() } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.8))
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 30)

            // ✅ Local loading overlay – will always appear because it's driven by @State
            if isShowingLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(2.0)
                        .tint(.white)
                    Text("Logging in...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
        }
        .errorAlert(message: $authVM.errorMessage)
        .navigationBarHidden(true)
        // Hide the loading overlay after login succeeds (userSession changes)
        .onReceive(authVM.$userSession) { session in
            if session != nil {
                isShowingLoading = false
            }
        }
        // Also hide if an error occurs – you might want to handle that
        .onReceive(authVM.$errorMessage) { error in
            if error != nil {
                isShowingLoading = false
            }
        }
    }

    private var canLogin: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }
}
