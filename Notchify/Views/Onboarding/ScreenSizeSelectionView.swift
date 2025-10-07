//
//  ScreenSizeSelectionView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct ScreenSizeSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 12) {
                Text("Select Your Mac Model")
                    .font(.system(size: 32, weight: .bold))

                Text("This helps us properly size the notch interface")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 16) {
                ForEach(MacBookModel.allCases, id: \.self) { model in
                    MacModelSelectionCard(
                        model: model,
                        isSelected: viewModel.selectedModel == model,
                        action: {
                            viewModel.selectModel(model)
                        }
                    )
                }
            }
            .padding(.horizontal, 40)

            if viewModel.selectedModel != nil {
                VStack(spacing: 8) {
                    Text("Selected: \(viewModel.selectedModel!.displayName)")
                        .font(.headline)
                        .foregroundColor(.blue)

                    Text("Notch dimensions: \(Int(viewModel.selectedModel!.notchDimensions.width))pt × \(Int(viewModel.selectedModel!.notchDimensions.height))pt")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.selectedModel)
    }
}

struct MacModelSelectionCard: View {
    let model: MacBookModel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: model.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 60)

                VStack(alignment: .leading, spacing: 6) {
                    Text(model.displayName)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .primary)

                    Text("\(Int(model.notchDimensions.width))pt wide × \(Int(model.notchDimensions.height))pt tall")
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    ScreenSizeSelectionView(viewModel: OnboardingViewModel())
        .frame(width: 600, height: 500)
}
