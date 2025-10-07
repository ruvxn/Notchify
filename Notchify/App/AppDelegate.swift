//
//  AppDelegate.swift
//  Notchify
//
//  Created by Claude Code
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var notchWindow: NSWindow?
    private var onboardingWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Check if onboarding is complete
        let isOnboardingComplete = UserDefaults.standard.bool(forKey: "isOnboardingComplete")

        if isOnboardingComplete {
            // Launch main app
            setupMenuBar()
            showNotchWindow()
        } else {
            // Show onboarding
            showOnboarding()
        }
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "macbook", accessibilityDescription: "Notchify")
            button.action = #selector(menuBarIconClicked)
            button.target = self
        }

        // Create menu
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Toggle Notch", action: #selector(toggleNotch), keyEquivalent: "t"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(showSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "Re-run Setup", action: #selector(showOnboarding), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Notchify", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    private func showNotchWindow() {
        let window = NotchWindowManager.shared.createNotchWindow()
        window.orderFrontRegardless()
        notchWindow = window
    }

    @objc private func showOnboarding() {
        // Create onboarding window
        let onboardingView = OnboardingView {
            // On completion, close onboarding and launch main app
            self.onboardingWindow?.close()
            self.onboardingWindow = nil
            self.setupMenuBar()
            self.showNotchWindow()
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.center()
        window.title = "Welcome to Notchify"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentView = NSHostingView(rootView: onboardingView)

        window.makeKeyAndOrderFront(nil)
        onboardingWindow = window

        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func menuBarIconClicked() {
        // Toggle menu
    }

    @objc private func toggleNotch() {
        NotchWindowManager.shared.toggle()
    }

    @objc private func showSettings() {
        // Show settings window
        let settingsView = SettingsView()
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.center()
        window.title = "Notchify Settings"
        window.titlebarAppearsTransparent = true
        window.contentView = NSHostingView(rootView: settingsView)
        window.makeKeyAndOrderFront(nil)

        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            // If no windows are visible, show the notch window
            showNotchWindow()
        }
        return true
    }
}
