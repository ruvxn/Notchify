//
//  NotchConfiguration.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation

struct NotchConfiguration: Codable {
    let model: MacBookModel
    var dimensions: NotchDimensions {
        model.notchDimensions
    }

    init(model: MacBookModel) {
        self.model = model
    }

    // Load configuration from UserDefaults
    static func loadSaved() -> NotchConfiguration? {
        guard let modelRaw = UserDefaults.standard.string(forKey: "selectedMacBookModel"),
              let model = MacBookModel(rawValue: modelRaw) else {
            return nil
        }
        return NotchConfiguration(model: model)
    }

    // Save configuration to UserDefaults
    func save() {
        UserDefaults.standard.set(model.rawValue, forKey: "selectedMacBookModel")
    }
}
