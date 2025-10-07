//
//  NotchContentView.swift
//  Notchify
//
//  Created by Claude Code
//

import SwiftUI

struct NotchContentView: View {
    @ObservedObject private var windowManager = NotchWindowManager.shared

    var body: some View {
        ZStack {
            if windowManager.isExpanded {
                ExpandedNotchView()
                    .transition(.scale.combined(with: .opacity))
            } else {
                CompactNotchView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: windowManager.isExpanded)
    }
}

#Preview {
    NotchContentView()
        .frame(width: 200, height: 32)
}
