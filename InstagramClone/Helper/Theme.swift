//
//  Theme.swift
//  InstagramClone
//
//  Created by Chetan purohit on 06/05/26.
//

import SwiftUI

extension Color {
    // Instagram gradient colours
    static let igPurple = Color(red: 131/255, green: 58/255, blue: 180/255)
    static let igPink   = Color(red: 253/255, green: 29/255, blue: 29/255)
    static let igOrange = Color(red: 252/255, green: 176/255, blue: 69/255)
    static let igYellow = Color(red: 255/255, green: 215/255, blue: 0)

    // Primary button colour
    static let igBlue   = Color(red: 0/255, green: 149/255, blue: 246/255)

    // Backgrounds
    static let igBackground = Color(.systemGroupedBackground)
    static let igCard        = Color(.systemBackground)

    // Text
    static let igPrimaryText  = Color(.label)
    static let igSecondaryText = Color(.secondaryLabel)
}

// Reusable Instagram gradient
extension View {
    func instagramGradient() -> some View {
        self.overlay(
            LinearGradient(
                colors: [.igPurple, .igPink, .igOrange, .igYellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// Simple button scale animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension View {
    func errorAlert(message: Binding<String?>) -> some View {
        self.alert("Error", isPresented: Binding<Bool>(
            get: { message.wrappedValue != nil },
            set: { if !$0 { message.wrappedValue = nil } }
        )) {
            Button("OK") { message.wrappedValue = nil }
        } message: {
            Text(message.wrappedValue ?? "")
        }
    }
}


