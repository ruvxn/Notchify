//
//  OllamaService.swift
//  Notchify
//
//  Created by Claude Code
//

import Foundation

class OllamaService: ObservableObject {
    static let shared = OllamaService()

    private let baseURL = "http://localhost:11434"
    private let model = "llama3.2:latest" // Your downloaded model

    @Published var isAvailable = false

    init() {
        checkAvailability()
    }

    // Check if Ollama is running
    func checkAvailability() {
        guard let url = URL(string: "\(baseURL)/api/tags") else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isAvailable = (error == nil && (response as? HTTPURLResponse)?.statusCode == 200)
            }
        }
        task.resume()
    }

    // Send a message and get response
    func sendMessage(_ message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/generate") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let requestBody: [String: Any] = [
            "model": model,
            "prompt": message,
            "stream": false
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "JSON Serialization failed", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 60 // Ollama can take time to respond

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1)))
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? String {
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Invalid response format", code: -1)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
