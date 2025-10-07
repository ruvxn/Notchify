//
//  CompactNotchView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct CompactNotchView: View {
    @StateObject private var mediaViewModel = MediaPlayerViewModel()
    @State private var isAnimating = false
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        HStack(spacing: 8) {
            // Left indicator - music note animation (shows when playing)
            if mediaViewModel.isPlaying {
                Image(systemName: "music.note")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
            }

            Spacer(minLength: 4)

            // Center content - now playing info
            if mediaViewModel.hasCurrentItem {
                VStack(spacing: 2) {
                    ScrollingText(text: mediaViewModel.displayTitle, isAnimating: $isAnimating)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))

                    Text(mediaViewModel.displayArtist)
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
            } else {
                Text("Notchify")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer(minLength: 4)

            // Right indicator - playback status
            if mediaViewModel.hasCurrentItem {
                Image(systemName: mediaViewModel.isPlaying ? "play.fill" : "pause.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.white.opacity(0.6))
            } else {
                // Notification badge when no music
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .padding(.bottom, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            MacBookNotchShape()
                .fill(Color.black)
        )
        .allowsHitTesting(false) // Let mouse events pass through to NotchTrackingView
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// Helper view for scrolling long text
struct ScrollingText: View {
    let text: String
    @Binding var isAnimating: Bool
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .lineLimit(1)
                .offset(x: text.count > 20 ? offset : 0)
                .onAppear {
                    if text.count > 20 {
                        startScrolling(width: geometry.size.width)
                    }
                }
        }
    }

    private func startScrolling(width: CGFloat) {
        let textWidth = CGFloat(text.count * 6) // Approximate width
        let scrollDistance = textWidth - width

        guard scrollDistance > 0 else { return }

        withAnimation(.linear(duration: Double(scrollDistance / 20)).repeatForever(autoreverses: true)) {
            offset = -scrollDistance
        }
    }
}

// Custom shape that matches MacBook notch design
struct MacBookNotchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let cornerRadius: CGFloat = 10

        // Start from top-left
        path.move(to: CGPoint(x: 0, y: 0))

        // Top edge (straight)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))

        // Top-right corner going down
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))

        // Bottom-right rounded corner
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        // Bottom edge
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.maxY))

        // Bottom-left rounded corner
        path.addArc(
            center: CGPoint(x: cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        // Left edge going back to top
        path.addLine(to: CGPoint(x: 0, y: 0))

        path.closeSubpath()

        return path
    }
}

#Preview {
    CompactNotchView()
        .frame(width: 200, height: 32)
        .background(Color.black)
}
