//
//  MacBookModel.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import CoreGraphics

enum MacBookModel: String, Codable, CaseIterable {
    case macBook14inch = "14-inch MacBook Pro"
    case macBook16inch = "16-inch MacBook Pro"
    case noNotch = "No Notch / Other Mac"

    var notchDimensions: NotchDimensions {
        switch self {
        case .macBook14inch:
            return NotchDimensions(width: 170, height: 32)
        case .macBook16inch:
            return NotchDimensions(width: 200, height: 37)
        case .noNotch:
            return NotchDimensions(width: 200, height: 32)
        }
    }

    var displayName: String {
        return self.rawValue
    }

    var iconName: String {
        switch self {
        case .macBook14inch, .macBook16inch:
            return "laptopcomputer"
        case .noNotch:
            return "desktopcomputer"
        }
    }
}
