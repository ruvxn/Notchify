//
//  MediaPlayerView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct MediaPlayerView: View {
    @StateObject private var viewModel = MediaPlayerViewModel()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with album art blur
                if let albumArt = viewModel.currentItem?.albumArt {
                    Image(nsImage: albumArt)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: 50)
                        .opacity(0.3)
                }

                // Main content
                VStack(spacing: 0) {
                    // Album art and track info
                    HStack(spacing: 16) {
                        // Album artwork
                        if let albumArt = viewModel.currentItem?.albumArt {
                            Image(nsImage: albumArt)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .shadow(radius: 10)
                        } else {
                            // Placeholder
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.largeTitle)
                                        .foregroundColor(.white.opacity(0.5))
                                )
                        }

                        // Track information
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.displayTitle)
                                .font(.headline)
                                .foregroundColor(.white)
                                .lineLimit(1)

                            Text(viewModel.displayArtist)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)

                            if !viewModel.displayAlbum.isEmpty {
                                Text(viewModel.displayAlbum)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                    .lineLimit(1)
                            }

                            // App badge
                            if !viewModel.displayAppName.isEmpty {
                                HStack(spacing: 4) {
                                    Image(systemName: "app.fill")
                                        .font(.caption2)
                                    Text(viewModel.displayAppName)
                                        .font(.caption2)
                                }
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                )
                                .padding(.top, 4)
                            }
                        }

                        Spacer()

                        // Waveform visualization (placeholder)
                        WaveformVisualization(isPlaying: viewModel.isPlaying)
                            .frame(width: 60, height: 80)
                    }
                    .padding()

                    // Progress bar
                    VStack(spacing: 4) {
                        // Seekable progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 4)

                                // Progress
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white)
                                    .frame(width: geo.size.width * viewModel.progress, height: 4)
                            }
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let progress = value.location.x / geo.size.width
                                        viewModel.seek(to: max(0, min(1, progress)))
                                    }
                            )
                        }
                        .frame(height: 20)

                        // Time labels
                        HStack {
                            Text(viewModel.currentTimeString)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))

                            Spacer()

                            Text(viewModel.durationString)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)

                    // Playback controls
                    HStack(spacing: 24) {
                        // Previous track
                        ControlButton(icon: "backward.fill") {
                            viewModel.previousTrack()
                        }

                        // Play/Pause
                        ControlButton(
                            icon: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill",
                            size: 44
                        ) {
                            viewModel.togglePlayPause()
                        }

                        // Next track
                        ControlButton(icon: "forward.fill") {
                            viewModel.nextTrack()
                        }
                    }
                    .padding(.vertical, 12)

                    // Volume control (simplified to avoid Slider glitches)
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.volume == 0 ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 20)

                        // Custom progress bar with tap/drag gesture
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 4)

                                // Volume level
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.8))
                                    .frame(width: geo.size.width * CGFloat(viewModel.volume), height: 4)
                            }
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let volume = Float(value.location.x / geo.size.width)
                                        viewModel.setVolume(max(0, min(1, volume)))
                                    }
                            )
                        }
                        .frame(height: 20)

                        Text("\(viewModel.volumePercentage)%")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 35, alignment: .trailing)
                    }
                    .frame(height: 20)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .background(Color.black)
    }
}

struct ControlButton: View {
    let icon: String
    var size: CGFloat = 32
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size - 8))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.15))
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: size)
    }
}

struct WaveformVisualization: View {
    let isPlaying: Bool
    @State private var animationPhase: CGFloat = 0

    private let barCount = 5

    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 4)
                    .frame(height: barHeight(for: index))
            }
        }
        .onAppear {
            if isPlaying {
                startAnimation()
            }
        }
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                startAnimation()
            }
        }
    }

    private func barHeight(for index: Int) -> CGFloat {
        if !isPlaying {
            return 20 // Static height when paused
        }

        let baseHeight: CGFloat = 20
        let maxHeight: CGFloat = 60

        // Create wave effect with phase offset
        let phase = animationPhase + (CGFloat(index) * 0.4)
        let height = baseHeight + (sin(phase) * 0.5 + 0.5) * (maxHeight - baseHeight)

        return height
    }

    private func startAnimation() {
        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            animationPhase = .pi * 2
        }
    }
}

#Preview {
    MediaPlayerView()
        .frame(width: 600, height: 256)
        .background(Color.black)
}
