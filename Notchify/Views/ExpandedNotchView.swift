//
//  ExpandedNotchView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct ExpandedNotchView: View {
    @State private var selectedTab: NotchTab = .media

    enum NotchTab: String, CaseIterable {
        case media = "Media"
        case calendar = "Calendar"
        case notifications = "Notifications"
        case chat = "Chat"

        var icon: String {
            switch self {
            case .media:
                return "music.note"
            case .calendar:
                return "calendar"
            case .notifications:
                return "bell.fill"
            case .chat:
                return "message.fill"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Tab selector
            HStack(spacing: 4) {
                ForEach(NotchTab.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }
                    )
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.95))

            Divider()
                .background(Color.white.opacity(0.1))

            // Content area
            Group {
                switch selectedTab {
                case .media:
                    MediaPlayerView()
                case .calendar:
                    CalendarPlaceholderView()
                case .notifications:
                    NotificationsPlaceholderView()
                case .chat:
                    ChatView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 10)
    }
}

struct TabButton: View {
    let tab: ExpandedNotchView.NotchTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 14))
                Text(tab.rawValue)
                    .font(.system(size: 9, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Placeholder views for remaining tabs
struct CalendarPlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))
            Text("Calendar")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            Text("Coming soon...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NotificationsPlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "bell.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))
            Text("Notifications")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            Text("Coming soon...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ChatPlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "message.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))
            Text("AI Chat")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            Text("Coming soon...")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ExpandedNotchView()
        .frame(width: 600, height: 256)
        .background(Color.black)
}
