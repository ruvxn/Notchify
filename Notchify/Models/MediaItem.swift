//
//  MediaItem.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import AppKit

struct MediaItem: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let album: String
    let albumArt: NSImage?
    let duration: TimeInterval
    let appName: String // "Spotify", "Music", "Safari", etc.

    var hasArtwork: Bool {
        albumArt != nil
    }

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // Placeholder for when nothing is playing
    static var placeholder: MediaItem {
        MediaItem(
            title: "No Media Playing",
            artist: "Select a song to start",
            album: "",
            albumArt: nil,
            duration: 0,
            appName: "None"
        )
    }
}

struct PlaybackState {
    var isPlaying: Bool = false
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var volume: Float = 0.5
    var currentItem: MediaItem?

    var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }

    var formattedCurrentTime: String {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
