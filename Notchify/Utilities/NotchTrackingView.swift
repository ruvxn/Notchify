//
//  NotchTrackingView.swift
//  Notchify
//
//  Created by Claude Code
//

import AppKit
import SwiftUI

class NotchTrackingView: NSView {
    var onMouseEntered: (() -> Void)?
    var onMouseExited: (() -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupTracking()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTracking()
    }

    private func setupTracking() {
        // Enable mouse tracking
        self.wantsLayer = true
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        // Remove existing tracking areas
        for trackingArea in trackingAreas {
            removeTrackingArea(trackingArea)
        }

        // Add new tracking area that covers entire bounds
        let options: NSTrackingArea.Options = [
            .mouseEnteredAndExited,
            .activeAlways,
            .inVisibleRect
        ]

        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: options,
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }

    // Check if mouse is currently inside the view
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateTrackingAreas()
    }

    override var bounds: NSRect {
        didSet {
            if bounds != oldValue {
                updateTrackingAreas()
            }
        }
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        onMouseEntered?()
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        onMouseExited?()
    }
}
