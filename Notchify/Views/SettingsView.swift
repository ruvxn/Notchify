//
//  SettingsView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @State private var selectedModel: MacBookModel
    @State private var launchAtLogin: Bool = false
    @ObservedObject private var permissionsManager = PermissionsManager.shared

    init() {
        // Load current configuration
        let config = NotchConfiguration.loadSaved() ?? NotchConfiguration(model: .macBook14inch)
        _selectedModel = State(initialValue: config.model)

        // Check launch at login status
        _launchAtLogin = State(initialValue: UserDefaults.standard.bool(forKey: "launchAtLogin"))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)

                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 30)
            .padding(.bottom, 20)

            Divider()

            // Settings content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // General settings
                    SettingsSection(title: "General") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mac Model")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Picker("", selection: $selectedModel) {
                                ForEach(MacBookModel.allCases, id: \.self) { model in
                                    Text(model.displayName).tag(model)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: selectedModel) { _, newValue in
                                updateMacModel(newValue)
                            }

                            Text("Selected: \(Int(selectedModel.notchDimensions.width))pt × \(Int(selectedModel.notchDimensions.height))pt")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Toggle("Launch at Login", isOn: $launchAtLogin)
                            .onChange(of: launchAtLogin) { _, newValue in
                                setLaunchAtLogin(newValue)
                            }
                    }

                    // Permissions
                    SettingsSection(title: "Permissions") {
                        VStack(alignment: .leading, spacing: 12) {
                            PermissionRow(
                                icon: "calendar",
                                title: "Calendar Access",
                                status: permissionsManager.calendarStatus,
                                action: {
                                    permissionsManager.requestCalendarAccess { _ in }
                                }
                            )

                            PermissionRow(
                                icon: "bell.badge",
                                title: "Notification Access",
                                status: permissionsManager.notificationStatus,
                                action: {
                                    permissionsManager.requestNotificationAccess { _ in }
                                }
                            )
                        }

                        Button("Open System Settings") {
                            permissionsManager.openSystemSettings()
                        }
                        .buttonStyle(.link)
                    }

                    // Advanced
                    SettingsSection(title: "Advanced") {
                        VStack(alignment: .leading, spacing: 12) {
                            Button("Reset All Settings") {
                                resetSettings()
                            }
                            .foregroundColor(.red)

                            Button("Re-run Setup") {
                                rerunSetup()
                            }
                        }
                    }
                }
                .padding(20)
            }

            Divider()

            // Footer
            HStack {
                Text("Notchify v1.0")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Button("Close") {
                    NSApp.keyWindow?.close()
                }
                .keyboardShortcut(.cancelAction)
            }
            .padding()
        }
        .frame(width: 500, height: 400)
    }

    private func updateMacModel(_ model: MacBookModel) {
        let config = NotchConfiguration(model: model)
        NotchWindowManager.shared.updateConfiguration(config)
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "launchAtLogin")

        // Note: Actual launch at login implementation requires SMAppService (macOS 13+)
        // For now, just save the preference
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to set launch at login: \(error)")
            }
        }
    }

    private func resetSettings() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        NSApp.keyWindow?.close()
    }

    private func rerunSetup() {
        UserDefaults.standard.set(false, forKey: "isOnboardingComplete")
        NSApp.keyWindow?.close()

        // Restart app to show onboarding
        NSApp.terminate(nil)
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 12) {
                content
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
            )
        }
    }
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let status: PermissionsManager.PermissionStatus
    let action: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)

            Text(title)
                .font(.body)

            Spacer()

            if status == .authorized {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Button(status == .denied ? "Denied" : "Grant") {
                    action()
                }
                .buttonStyle(.borderedProminent)
                .tint(status == .denied ? .red : .blue)
                .disabled(status == .denied)
            }
        }
    }
}

#Preview {
    SettingsView()
}
