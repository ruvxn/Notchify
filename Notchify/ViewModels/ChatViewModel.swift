//
//  ChatViewModel.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let ollamaService = OllamaService.shared

    var isOllamaAvailable: Bool {
        ollamaService.isAvailable
    }

    init() {
        // Add welcome message
        messages.append(ChatMessage(
            content: "Hi! I'm your AI assistant powered by Ollama. How can I help you today?",
            isUser: false
        ))
    }

    func sendMessage() {
        guard !currentInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let userMessage = currentInput
        currentInput = ""

        // Add user message to chat
        messages.append(ChatMessage(content: userMessage, isUser: true))

        // Check if Ollama is available
        if !ollamaService.isAvailable {
            messages.append(ChatMessage(
                content: "Ollama is not running. Please start Ollama to use the AI chat feature.",
                isUser: false
            ))
            return
        }

        // Show loading state
        isLoading = true
        errorMessage = nil

        // Send to Ollama
        ollamaService.sendMessage(userMessage) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let response):
                self.messages.append(ChatMessage(content: response, isUser: false))

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.messages.append(ChatMessage(
                    content: "Sorry, I encountered an error: \(error.localizedDescription)",
                    isUser: false
                ))
            }
        }
    }

    func clearChat() {
        messages.removeAll()
        messages.append(ChatMessage(
            content: "Chat cleared. How can I help you?",
            isUser: false
        ))
    }
}
