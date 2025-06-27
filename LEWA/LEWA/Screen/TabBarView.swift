//
//  TabBarView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var store = WordsStore()

    var body: some View {
        NavigationStack {
            TabView {
                ContentView()
                    .environmentObject(store)
                    .tabItem { Label("search", systemImage: "magnifyingglass") }

                WordStarredView()
                    .environmentObject(store)
                    .tabItem { Label("star", systemImage: "star.fill") }
            }
        }
        .task { await store.load() }          // ← fetch words.json once
    }
}


#Preview {
    TabBarView()
}

import Foundation
import SwiftUI

@MainActor
final class WordsStore: ObservableObject {
    @Published private(set) var words: [Word] = []

    /// Load once and memoise.
    func load() async {
        guard words.isEmpty else { return }

        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
            assertionFailure("words.json missing from bundle")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Word].self, from: data)
            words = decoded
        } catch {
            assertionFailure("Failed to decode words.json – \(error)")
        }
    }

    /// Convenience helper
    func word(forID id: String) -> Word? {
        words.first { $0.root == id }
    }
}
