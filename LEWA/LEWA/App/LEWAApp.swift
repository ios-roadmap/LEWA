//
//  LEWAApp.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 22.06.2025.
//

import SwiftUI

@main
struct LEWAApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .modelContainer(for: [StarredWord.self])
        }
    }
}
// MARK: – ContentView
/// Loads the JSON file and shows the searchable dictionary.
struct ContentView: View {
    @State private var words: [Word] = []

    var body: some View {
        NavigationStack {
            if words.isEmpty {
                ProgressView("Loading…")
                    .task(loadWords)
            } else {
                WordSearchView(words: words)
            }
        }
    }

    private func loadWords() async {
        do {
            // 1️⃣ Locate the file
            guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
                print("❌ words.json not found in the main bundle.")
                return
            }

            // 2️⃣ Read the data
            let data: Data
            do {
                data = try Data(contentsOf: url)
            } catch {
                print("❌ Could not read data from words.json: \(error)")
                return
            }

            // 3️⃣ Decode the data
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // safer, but optional
            let decoded: [Word]
            do {
                decoded = try decoder.decode([Word].self, from: data)
            } catch {
                print("❌ JSON decoding failed: \(error)")
                return
            }

            // 4️⃣ Publish on the main actor
            await MainActor.run { words = decoded }
        }
    }

}
