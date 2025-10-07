//
//  WelcomeView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // App Icon/Logo
            Image(systemName: "macbook")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.linearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            VStack(spacing: 12) {
                Text("Welcome to Notchify")
                    .font(.system(size: 36, weight: .bold))

                Text("Transform your notch into a powerful productivity hub")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(
                    icon: "music.note",
                    title: "Media Control",
                    description: "Control your music with a beautiful interface"
                )

                FeatureRow(
                    icon: "calendar",
                    title: "Calendar Integration",
                    description: "View your upcoming events at a glance"
                )

                FeatureRow(
                    icon: "bell.badge",
                    title: "Notification Center",
                    description: "Manage your notifications seamlessly"
                )

                FeatureRow(
                    icon: "message",
                    title: "AI Chat",
                    description: "Chat with local LLM powered by Ollama"
                )
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

#Preview {
    WelcomeView()
        .frame(width: 600, height: 500)
}
