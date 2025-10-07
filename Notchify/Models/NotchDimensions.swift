//
//  NotchDimensions.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import CoreGraphics

struct NotchDimensions: Codable {
    let width: CGFloat
    let height: CGFloat

    // Multipliers for expanded state
    static let expandedWidthMultiplier: CGFloat = 3.0
    static let expandedHeightMultiplier: CGFloat = 10.0

    // Computed properties for expanded dimensions
    var expandedWidth: CGFloat {
        width * NotchDimensions.expandedWidthMultiplier
    }

    var expandedHeight: CGFloat {
        height * NotchDimensions.expandedHeightMultiplier
    }

    // Predefined dimensions for reference
    static let macBook14 = CGSize(width: 170, height: 32)
    static let macBook16 = CGSize(width: 200, height: 37)

    var compactSize: CGSize {
        CGSize(width: width, height: height)
    }

    var expandedSize: CGSize {
        CGSize(width: expandedWidth, height: expandedHeight)
    }
}
