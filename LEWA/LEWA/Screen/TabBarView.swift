//
//  TabBarView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct TabBarView: View {
    @StateObject private var store = WordsStore()
    @State private var loadingStart: Date?
    @State private var elapsed: Double = 0
    @State private var isLoading = false

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView {
            Group {
                if store.words.isEmpty || isLoading {
                    VStack {
                        ProgressView()
                        Text(String(format: "Loading... %.2fs", elapsed))
                            .monospacedDigit()
                            .font(.headline)
                    }
                    .onAppear {
                        print("onAppear: Loading started")
                        loadingStart = Date()
                        elapsed = 0
                        isLoading = true
                    }
                    .onChange(of: isLoading) { _, newValue in
                        if newValue == false {
                            guard isLoading, let start = loadingStart else { return }
                            elapsed = Date().timeIntervalSince(start)
                            print("Loading finished in \(elapsed) seconds")
                        }
                    }

                    .task {
                        await store.load()
                        print(elapsed)
                        isLoading = false
                        print("Loading finished")
                    }
                } else {
                    NavigationStack {
                        WordSearchView(words: store.words)
                            .environmentObject(store)
                    }
                }
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
            }
            
            NavigationStack {
                WordStarredView()
                    .environmentObject(store)
            }
            .tabItem {
                Image(systemName: "star.fill")
                    .imageScale(.large)
            }
        }
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
        
        guard let url = Bundle.main.url(forResource: "wordsNew", withExtension: "json") else {
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
