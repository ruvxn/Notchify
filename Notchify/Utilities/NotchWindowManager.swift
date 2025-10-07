//
//  NotchWindowManager.swift
//  Notchify
//
//  Created by Claude Code
//

import AppKit
import SwiftUI

class NotchWindowManager: NSObject, ObservableObject {
    static let shared = NotchWindowManager()

    @Published var isExpanded = false
    @Published var configuration: NotchConfiguration

    private var notchWindow: NSWindow?
    private var isAnimating = false
    private var hoverTimer: Timer?
    private var expandCompletedTime: Date?

    override init() {
        // Load saved configuration or use default
        self.configuration = NotchConfiguration.loadSaved() ?? NotchConfiguration(model: .macBook14inch)
        super.init()
    }

    func createNotchWindow() -> NSWindow {
        let dimensions = configuration.dimensions
        guard let screen = NSScreen.main else {
            fatalError("No main screen found")
        }

        let screenWidth = screen.frame.width
        let screenHeight = screen.frame.height

        // Center the notch horizontally at the top of the screen
        let xPosition = (screenWidth - dimensions.width) / 2
        let yPosition = screenHeight - dimensions.height

        let window = NSWindow(
            contentRect: NSRect(
                x: xPosition,
                y: yPosition,
                width: dimensions.width,
                height: dimensions.height
            ),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        // Configure window properties
        window.level = .statusBar
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.isMovable = false
        window.ignoresMouseEvents = false

        // Set up the content view with tracking
        let trackingView = NotchTrackingView()
        trackingView.autoresizingMask = [.width, .height]
        trackingView.wantsLayer = true
        trackingView.layer?.backgroundColor = .clear

        // Set up mouse event callbacks
        trackingView.onMouseEntered = { [weak self] in
            self?.expand()
        }
        trackingView.onMouseExited = { [weak self] in
            self?.collapse()
        }

        // Add SwiftUI content as a subview
        let hostingView = NSHostingView(rootView: NotchContentView())
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        // Allow mouse events to pass through to tracking view
        hostingView.wantsLayer = true
        hostingView.layer?.masksToBounds = false
        trackingView.addSubview(hostingView)

        // Pin hosting view to tracking view edges
        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: trackingView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: trackingView.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: trackingView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: trackingView.bottomAnchor)
        ])

        window.contentView = trackingView

        self.notchWindow = window
        return window
    }

    func expand() {
        // Cancel any pending collapse immediately
        hoverTimer?.invalidate()
        hoverTimer = nil

        // Ignore if already expanded
        guard !isExpanded, let window = notchWindow, let screen = NSScreen.main else { return }

        // Don't block on isAnimating for expand - interrupt if needed
        isExpanded = true
        isAnimating = true

        let dimensions = configuration.dimensions
        let screenWidth = screen.frame.width
        let screenHeight = screen.frame.height

        // Calculate expanded frame
        let expandedWidth = dimensions.expandedWidth
        let expandedHeight = dimensions.expandedHeight
        let xPosition = (screenWidth - expandedWidth) / 2
        let yPosition = screenHeight - expandedHeight

        let newFrame = NSRect(
            x: xPosition,
            y: yPosition,
            width: expandedWidth,
            height: expandedHeight
        )

        // Animate the expansion with fast spring animation
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().setFrame(newFrame, display: true)
        }, completionHandler: { [weak self] in
            self?.isAnimating = false
            self?.expandCompletedTime = Date()
            // Force tracking area update after expansion
            if let trackingView = window.contentView as? NotchTrackingView {
                trackingView.updateTrackingAreas()
            }
        })
    }

    func collapse() {
        // Ignore if already collapsed
        guard isExpanded, let window = notchWindow, let screen = NSScreen.main else { return }

        // Don't collapse if we're still animating the expansion
        if isAnimating {
            return
        }

        // Ignore collapse attempts within 0.15s of expansion completing (grace period)
        if let expandTime = expandCompletedTime, Date().timeIntervalSince(expandTime) < 0.15 {
            return
        }

        // Add a delay before collapsing to allow interaction
        hoverTimer?.invalidate()
        hoverTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            // Double check we're still expanded (user might have re-entered)
            guard self.isExpanded else { return }

            self.isExpanded = false
            self.isAnimating = true

            let dimensions = self.configuration.dimensions
            let screenWidth = screen.frame.width
            let screenHeight = screen.frame.height

            // Calculate compact frame
            let xPosition = (screenWidth - dimensions.width) / 2
            let yPosition = screenHeight - dimensions.height

            let newFrame = NSRect(
                x: xPosition,
                y: yPosition,
                width: dimensions.width,
                height: dimensions.height
            )

            // Animate the collapse
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                window.animator().setFrame(newFrame, display: true)
            }, completionHandler: { [weak self] in
                self?.isAnimating = false
                // Force tracking area update after collapse
                if let trackingView = window.contentView as? NotchTrackingView {
                    trackingView.updateTrackingAreas()
                }
            })
        }
    }

    func toggle() {
        if isExpanded {
            collapse()
        } else {
            expand()
        }
    }

    func updateConfiguration(_ newConfiguration: NotchConfiguration) {
        configuration = newConfiguration
        configuration.save()

        // Recreate window with new dimensions
        if let window = notchWindow {
            window.close()
            notchWindow = nil
        }

        let newWindow = createNotchWindow()
        newWindow.makeKeyAndOrderFront(nil)
    }
}
