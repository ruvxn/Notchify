//
//  PermissionsView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct PermissionsView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 12) {
                Text("Set Up Permissions")
                    .font(.system(size: 32, weight: .bold))

                Text("Grant permissions to unlock full functionality")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                PermissionCard(
                    icon: "calendar",
                    title: "Calendar Access",
                    description: "View your upcoming events in the notch",
                    isGranted: viewModel.hasCalendarPermission,
                    action: {
                        viewModel.requestCalendarPermission()
                    }
                )

                PermissionCard(
                    icon: "bell.badge",
                    title: "Notification Access",
                    description: "Monitor and display system notifications",
                    isGranted: viewModel.hasNotificationPermission,
                    action: {
                        viewModel.requestNotificationPermission()
                    }
                )

                OllamaConnectionCard(viewModel: viewModel)
            }
            .padding(.horizontal, 40)

            Text("You can skip these steps and configure them later in settings")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let isGranted: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.blue)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isGranted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            } else {
                Button("Grant Access") {
                    action()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct OllamaConnectionCard: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "message.badge.waveform")
                .font(.system(size: 32))
                .foregroundColor(.purple)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 6) {
                Text("Ollama Connection")
                    .font(.headline)
                Text("Connect to local LLM for AI chat features")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if viewModel.isCheckingOllama {
                ProgressView()
                    .scaleEffect(0.8)
            } else if viewModel.ollamaConnected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            } else {
                Button("Check Connection") {
                    viewModel.checkOllamaConnection()
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .onAppear {
            viewModel.checkOllamaConnection()
        }
    }
}

#Preview {
    PermissionsView(viewModel: OnboardingViewModel())
        .frame(width: 600, height: 500)
}
