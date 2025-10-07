//
//  MediaService.swift
//  Notchify
//
//

import Foundation
import MediaPlayer
import AppKit

class MediaService: ObservableObject {
    static let shared = MediaService()

    @Published var playbackState = PlaybackState()
    @Published var currentItem: MediaItem?

    private var updateTimer: Timer?
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    private var artworkCache: [String: NSImage] = [:] // Cache artwork by URL

    init() {
        setupRemoteCommands()
        startMonitoring()
    }

    // MARK: - Setup

    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        // Play command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] event in
            self?.play()
            return .success
        }

        // Pause command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] event in
            self?.pause()
            return .success
        }

        // Toggle play/pause
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] event in
            self?.togglePlayPause()
            return .success
        }

        // Next track
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            self?.nextTrack()
            return .success
        }

        // Previous track
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            self?.previousTrack()
            return .success
        }

        // Change playback position
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                self?.seek(to: event.positionTime)
                return .success
            }
            return .commandFailed
        }
    }

    private func startMonitoring() {
        // Note: MPNowPlayingInfoDidChange notification is not available on macOS
        // We'll rely on polling instead

        // Poll for updates every 0.5 seconds
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updatePlaybackState()
        }
    }

    // MARK: - Playback State Updates

    private func updatePlaybackState() {
        // Try Spotify first, then Music app
        if let spotifyInfo = getSpotifyPlaybackInfo() {
            DispatchQueue.main.async {
                self.currentItem = spotifyInfo.mediaItem
                self.playbackState.currentItem = spotifyInfo.mediaItem
                self.playbackState.currentTime = spotifyInfo.currentTime
                self.playbackState.duration = spotifyInfo.duration
                self.playbackState.isPlaying = spotifyInfo.isPlaying
            }
        } else if let musicInfo = getMusicPlaybackInfo() {
            DispatchQueue.main.async {
                self.currentItem = musicInfo.mediaItem
                self.playbackState.currentItem = musicInfo.mediaItem
                self.playbackState.currentTime = musicInfo.currentTime
                self.playbackState.duration = musicInfo.duration
                self.playbackState.isPlaying = musicInfo.isPlaying
            }
        } else {
            // Nothing playing
            DispatchQueue.main.async {
                self.playbackState.isPlaying = false
                self.currentItem = nil
            }
        }
    }

    private struct PlaybackInfo {
        let mediaItem: MediaItem
        let currentTime: TimeInterval
        let duration: TimeInterval
        let isPlaying: Bool
    }

    private func getSpotifyPlaybackInfo() -> PlaybackInfo? {
        let script = """
        tell application "System Events"
            set isRunning to (name of processes) contains "Spotify"
        end tell

        if isRunning then
            tell application "Spotify"
                if player state is playing or player state is paused then
                    set trackName to name of current track
                    set artistName to artist of current track
                    set albumName to album of current track
                    set trackDuration to duration of current track
                    set trackPosition to player position
                    set isPlaying to (player state is playing)
                    set artworkURL to artwork url of current track

                    return trackName & "|" & artistName & "|" & albumName & "|" & trackDuration & "|" & trackPosition & "|" & isPlaying & "|" & artworkURL
                end if
            end tell
        end if

        return "NO_DATA"
        """

        guard let result = executeAppleScriptWithResult(script),
              result != "NO_DATA" else {
            return nil
        }

        let components = result.components(separatedBy: "|")
        guard components.count == 7 else { return nil }

        // Fetch album artwork from URL (with caching)
        var albumArt: NSImage?
        let artworkURLString = components[6]
        if let cachedImage = artworkCache[artworkURLString] {
            albumArt = cachedImage
        } else if let artworkURL = URL(string: artworkURLString) {
            albumArt = fetchImageFromURL(artworkURL)
            if let albumArt = albumArt {
                artworkCache[artworkURLString] = albumArt
            }
        }

        let mediaItem = MediaItem(
            title: components[0],
            artist: components[1],
            album: components[2],
            albumArt: albumArt,
            duration: TimeInterval(Double(components[3]) ?? 0) / 1000.0, // Spotify returns milliseconds
            appName: "Spotify"
        )

        return PlaybackInfo(
            mediaItem: mediaItem,
            currentTime: TimeInterval(Double(components[4]) ?? 0), // Spotify position is in seconds
            duration: mediaItem.duration,
            isPlaying: components[5].lowercased() == "true"
        )
    }

    private func getMusicPlaybackInfo() -> PlaybackInfo? {
        let script = """
        tell application "System Events"
            set isRunning to (name of processes) contains "Music"
        end tell

        if isRunning then
            tell application "Music"
                if player state is playing or player state is paused then
                    set trackName to name of current track
                    set artistName to artist of current track
                    set albumName to album of current track
                    set trackDuration to duration of current track
                    set trackPosition to player position
                    set isPlaying to (player state is playing)

                    return trackName & "|" & artistName & "|" & albumName & "|" & trackDuration & "|" & trackPosition & "|" & isPlaying
                end if
            end tell
        end if

        return "NO_DATA"
        """

        guard let result = executeAppleScriptWithResult(script),
              result != "NO_DATA" else {
            return nil
        }

        let components = result.components(separatedBy: "|")
        guard components.count == 6 else { return nil }

        // Fetch album artwork from Music app using different AppleScript
        let albumArt = getMusicArtwork()

        let mediaItem = MediaItem(
            title: components[0],
            artist: components[1],
            album: components[2],
            albumArt: albumArt,
            duration: TimeInterval(Double(components[3]) ?? 0),
            appName: "Music"
        )

        return PlaybackInfo(
            mediaItem: mediaItem,
            currentTime: TimeInterval(Double(components[4]) ?? 0),
            duration: mediaItem.duration,
            isPlaying: components[5].lowercased() == "true"
        )
    }

    private func getMusicArtwork() -> NSImage? {
        let script = """
        tell application "Music"
            try
                set artworkData to raw data of artwork 1 of current track
                return artworkData
            on error
                return missing value
            end try
        end tell
        """

        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let result = scriptObject.executeAndReturnError(&error)
            if error == nil {
                let data = result.data
                return NSImage(data: data)
            }
        }
        return nil
    }

    private func detectPlayingApp() -> String {
        // Try to detect which app is playing
        // This is an approximation as macOS doesn't always provide this info

        let runningApps = NSWorkspace.shared.runningApplications

        // Check common media apps
        let mediaApps = ["Spotify", "Music", "Safari", "Chrome", "Firefox", "VLC"]

        for appName in mediaApps {
            if runningApps.contains(where: { $0.localizedName == appName }) {
                // Further check if this app is likely playing
                // For now, just return the first media app found
                return appName
            }
        }

        return "Music"
    }

    private func isActuallyPlaying() -> Bool {
        // Check if playback rate > 0 (indicates playing)
        if let rate = nowPlayingInfoCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] as? Double {
            return rate > 0
        }

        // Fallback: assume playing if we have now playing info
        return nowPlayingInfoCenter.nowPlayingInfo != nil
    }

    // MARK: - Playback Controls

    func play() {
        sendAppleScriptCommand(.play)
        DispatchQueue.main.async {
            self.playbackState.isPlaying = true
        }
    }

    func pause() {
        sendAppleScriptCommand(.pause)
        DispatchQueue.main.async {
            self.playbackState.isPlaying = false
        }
    }

    func togglePlayPause() {
        if playbackState.isPlaying {
            pause()
        } else {
            play()
        }
    }

    func nextTrack() {
        sendAppleScriptCommand(.next)
    }

    func previousTrack() {
        sendAppleScriptCommand(.previous)
    }

    func seek(to time: TimeInterval) {
        // Don't seek if no current item
        guard let currentItem = currentItem else { return }

        // Clamp time to valid range
        let clampedTime = max(0, min(time, playbackState.duration))

        // Update local state immediately for responsive UI
        DispatchQueue.main.async {
            self.playbackState.currentTime = clampedTime
        }

        // Send seek command to the actual app
        let appName = currentItem.appName
        let script: String

        if appName == "Spotify" {
            // Spotify player position is in seconds (not milliseconds)
            let positionSeconds = Int(clampedTime)
            script = """
            tell application "Spotify"
                try
                    set player position to \(positionSeconds)
                on error errMsg
                    log "Seek error: " & errMsg
                end try
            end tell
            """
        } else if appName == "Music" {
            // Music uses seconds
            script = """
            tell application "Music"
                try
                    set player position to \(clampedTime)
                on error errMsg
                    log "Seek error: " & errMsg
                end try
            end tell
            """
        } else {
            return
        }

        executeAppleScript(script)
    }

    func setVolume(_ volume: Float) {
        let clampedVolume = max(0, min(1, volume))
        DispatchQueue.main.async {
            self.playbackState.volume = clampedVolume
        }

        // Set system volume (requires permissions)
        sendVolumeCommand(clampedVolume)
    }

    // MARK: - AppleScript Integration

    private enum PlaybackCommand {
        case play
        case pause
        case next
        case previous
    }

    private func sendAppleScriptCommand(_ command: PlaybackCommand) {
        // Determine which app is playing
        let appName = currentItem?.appName ?? "Spotify"

        let script: String
        switch command {
        case .play:
            script = """
            tell application "\(appName)"
                play
            end tell
            """
        case .pause:
            script = """
            tell application "\(appName)"
                pause
            end tell
            """
        case .next:
            script = """
            tell application "\(appName)"
                next track
            end tell
            """
        case .previous:
            script = """
            tell application "\(appName)"
                previous track
            end tell
            """
        }

        executeAppleScript(script)
    }

    private func sendVolumeCommand(_ volume: Float) {
        let volumePercent = Int(volume * 100)
        let script = """
        set volume output volume \(volumePercent)
        """
        executeAppleScript(script)
    }

    private func executeAppleScript(_ script: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("AppleScript error: \(error)")
            }
        }
    }

    private func executeAppleScriptWithResult(_ script: String) -> String? {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let result = scriptObject.executeAndReturnError(&error)
            if let error = error {
                print("AppleScript error: \(error)")
                return nil
            }
            return result.stringValue
        }
        return nil
    }

    private func fetchImageFromURL(_ url: URL) -> NSImage? {
        // Use a semaphore to make async call synchronous but off main thread
        var image: NSImage?
        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { semaphore.signal() }

            if let error = error {
                print("Failed to fetch artwork from URL: \(error)")
                return
            }

            if let data = data {
                image = NSImage(data: data)
            }
        }

        task.resume()
        semaphore.wait()

        return image
    }

    private func updateNowPlayingInfo() {
        // Update the now playing info center with current state
        guard let item = currentItem else { return }

        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = item.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = item.artist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = item.album
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playbackState.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackState.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playbackState.isPlaying ? 1.0 : 0.0

        if let artwork = item.albumArt {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size) { _ in
                return artwork
            }
        }

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Cleanup

    deinit {
        updateTimer?.invalidate()
    }
}
