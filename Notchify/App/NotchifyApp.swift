//
//  NotchifyApp.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

@main
struct NotchifyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Menu bar only app - no main window
        Settings {
            EmptyView()
        }
    }
}
