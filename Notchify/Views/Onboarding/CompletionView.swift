//
//  CompletionView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct CompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.green)

            VStack(spacing: 12) {
                Text("All Set!")
                    .font(.system(size: 36, weight: .bold))

                Text("Notchify is ready to enhance your Mac experience")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 16) {
                QuickTipRow(
                    icon: "hand.tap",
                    text: "Hover over the notch to expand the interface"
                )

                QuickTipRow(
                    icon: "arrow.left.arrow.right",
                    text: "Switch between tabs to access different features"
                )

                QuickTipRow(
                    icon: "gearshape",
                    text: "Access settings from the menu bar icon"
                )

                QuickTipRow(
                    icon: "escape",
                    text: "Click outside to collapse the notch view"
                )
            }
            .padding(.horizontal, 40)

            Spacer()

            VStack(spacing: 8) {
                if let model = viewModel.selectedModel {
                    Text("Configured for: \(model.displayName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 12) {
                    if viewModel.hasCalendarPermission {
                        Label("Calendar", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }

                    if viewModel.hasNotificationPermission {
                        Label("Notifications", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }

                    if viewModel.ollamaConnected {
                        Label("Ollama", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct QuickTipRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 24)

            Text(text)
                .font(.subheadline)

            Spacer()
        }
    }
}

#Preview {
    CompletionView(viewModel: OnboardingViewModel())
        .frame(width: 600, height: 500)
}
