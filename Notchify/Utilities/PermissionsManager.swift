//
//  PermissionsManager.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import AppKit
import EventKit
import UserNotifications

class PermissionsManager: ObservableObject {
    static let shared = PermissionsManager()

    @Published var calendarStatus: PermissionStatus = .notDetermined
    @Published var notificationStatus: PermissionStatus = .notDetermined

    private let eventStore = EKEventStore()

    enum PermissionStatus {
        case notDetermined
        case denied
        case authorized
        case restricted
    }

    init() {
        checkAllPermissions()
    }

    // MARK: - Calendar Permissions
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        if #available(macOS 14.0, *) {
            eventStore.requestFullAccessToEvents { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.calendarStatus = granted ? .authorized : .denied
                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.calendarStatus = granted ? .authorized : .denied
                    completion(granted)
                }
            }
        }
    }

    func checkCalendarPermission() -> PermissionStatus {
        let status: EKAuthorizationStatus
        if #available(macOS 14.0, *) {
            status = EKEventStore.authorizationStatus(for: .event)
        } else {
            status = EKEventStore.authorizationStatus(for: .event)
        }

        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .fullAccess, .authorized:
            return .authorized
        case .writeOnly:
            return .denied
        @unknown default:
            return .notDetermined
        }
    }

    // MARK: - Notification Permissions
    func requestNotificationAccess(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.notificationStatus = granted ? .authorized : .denied
                completion(granted)
            }
        }
    }

    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self?.notificationStatus = .notDetermined
                case .denied:
                    self?.notificationStatus = .denied
                case .authorized, .provisional, .ephemeral:
                    self?.notificationStatus = .authorized
                @unknown default:
                    self?.notificationStatus = .notDetermined
                }
            }
        }
    }

    // MARK: - Check All Permissions
    func checkAllPermissions() {
        calendarStatus = checkCalendarPermission()
        checkNotificationPermission()
    }

    // MARK: - Open System Settings
    func openSystemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy") {
            NSWorkspace.shared.open(url)
        }
    }
}
