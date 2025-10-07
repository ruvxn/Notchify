//
//  OnboardingViewModel.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var selectedModel: MacBookModel?
    @Published var hasCalendarPermission = false
    @Published var hasNotificationPermission = false
    @Published var ollamaConnected = false
    @Published var isCheckingOllama = false

    private let permissionsManager = PermissionsManager.shared

    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case screenSize = 1
        case permissions = 2
        case complete = 3

        var title: String {
            switch self {
            case .welcome:
                return "Welcome to Notchify"
            case .screenSize:
                return "Select Your Mac Model"
            case .permissions:
                return "Set Up Permissions"
            case .complete:
                return "All Set!"
            }
        }

        var canGoNext: Bool {
            self != .complete
        }

        var canGoBack: Bool {
            self != .welcome
        }
    }

    var progress: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }

    var canContinue: Bool {
        switch currentStep {
        case .welcome:
            return true
        case .screenSize:
            return selectedModel != nil
        case .permissions:
            return true // Can always continue, permissions are optional
        case .complete:
            return false
        }
    }

    func nextStep() {
        guard canContinue else { return }

        if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentStep = nextStep
            }
        }
    }

    func previousStep() {
        if let prevStep = OnboardingStep(rawValue: currentStep.rawValue - 1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentStep = prevStep
            }
        }
    }

    func selectModel(_ model: MacBookModel) {
        selectedModel = model
    }

    func requestCalendarPermission() {
        permissionsManager.requestCalendarAccess { [weak self] granted in
            self?.hasCalendarPermission = granted
        }
    }

    func requestNotificationPermission() {
        permissionsManager.requestNotificationAccess { [weak self] granted in
            self?.hasNotificationPermission = granted
        }
    }

    func checkOllamaConnection() {
        isCheckingOllama = true

        guard let url = URL(string: "http://localhost:11434/api/tags") else {
            isCheckingOllama = false
            ollamaConnected = false
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 2.0

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isCheckingOllama = false
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    self?.ollamaConnected = true
                } else {
                    self?.ollamaConnected = false
                }
            }
        }.resume()
    }

    func completeOnboarding() {
        guard let selectedModel = selectedModel else { return }

        // Save configuration
        let configuration = NotchConfiguration(model: selectedModel)
        configuration.save()

        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "isOnboardingComplete")

        // Save permission states
        UserDefaults.standard.set(hasCalendarPermission, forKey: "hasCalendarPermission")
        UserDefaults.standard.set(hasNotificationPermission, forKey: "hasNotificationPermission")
        UserDefaults.standard.set(ollamaConnected, forKey: "ollamaConnected")
    }

    func skipPermissions() {
        nextStep()
    }
}
