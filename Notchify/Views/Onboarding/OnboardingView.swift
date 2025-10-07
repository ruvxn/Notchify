//
//  OnboardingView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss

    var onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .tint(.blue)

            // Content
            ZStack {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))

                case .screenSize:
                    ScreenSizeSelectionView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))

                case .permissions:
                    PermissionsView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))

                case .complete:
                    CompletionView(viewModel: viewModel)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Navigation buttons
            HStack {
                if viewModel.currentStep.canGoBack {
                    Button("Back") {
                        viewModel.previousStep()
                    }
                    .keyboardShortcut(.cancelAction)
                }

                Spacer()

                if viewModel.currentStep == .permissions {
                    Button("Skip") {
                        viewModel.skipPermissions()
                    }
                }

                if viewModel.currentStep.canGoNext {
                    Button(viewModel.currentStep == .permissions ? "Continue" : "Next") {
                        viewModel.nextStep()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.canContinue)
                    .keyboardShortcut(.defaultAction)
                } else {
                    Button("Launch App") {
                        viewModel.completeOnboarding()
                        onComplete()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 600, height: 500)
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
