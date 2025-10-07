//
//  MediaPlayerViewModel.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import Combine

class MediaPlayerViewModel: ObservableObject {
    @Published var currentItem: MediaItem?
    @Published var playbackState: PlaybackState
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 0.5

    private let mediaService = MediaService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.playbackState = mediaService.playbackState

        // Subscribe to media service updates
        mediaService.$currentItem
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentItem)

        mediaService.$playbackState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.playbackState = state
                self?.isPlaying = state.isPlaying
                self?.volume = state.volume
            }
            .store(in: &cancellables)
    }

    // MARK: - Playback Controls

    func togglePlayPause() {
        mediaService.togglePlayPause()
    }

    func play() {
        mediaService.play()
    }

    func pause() {
        mediaService.pause()
    }

    func nextTrack() {
        mediaService.nextTrack()
    }

    func previousTrack() {
        mediaService.previousTrack()
    }

    func seek(to progress: Double) {
        let time = progress * playbackState.duration
        mediaService.seek(to: time)
    }

    func setVolume(_ newVolume: Float) {
        mediaService.setVolume(newVolume)
    }

    // MARK: - Computed Properties

    var hasCurrentItem: Bool {
        currentItem != nil && currentItem?.title != "No Media Playing"
    }

    var displayTitle: String {
        currentItem?.title ?? "No Media Playing"
    }

    var displayArtist: String {
        currentItem?.artist ?? "Select a song to start"
    }

    var displayAlbum: String {
        currentItem?.album ?? ""
    }

    var displayAppName: String {
        currentItem?.appName ?? ""
    }

    var progress: Double {
        playbackState.progress
    }

    var currentTimeString: String {
        playbackState.formattedCurrentTime
    }

    var durationString: String {
        playbackState.formattedDuration
    }

    var volumePercentage: Int {
        Int(volume * 100)
    }
}
