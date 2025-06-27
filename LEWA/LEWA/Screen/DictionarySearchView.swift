//
//  DictionarySearchView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import SwiftUI

/// Simple domain model. Replace with your real entity if needed.
struct Word: Identifiable, Hashable {
    let id = UUID()
    let text: String
}

/// Main dictionary search page with A–Z index, search, and fast‑scroll support. Compatible with iOS 17+.
struct DictionarySearchView: View {
    // MARK: – State
    @State private var searchText = ""
    @State private var isSearching = false   // NEW

    // MARK: – Data source (demo)
    private let words: [Word] = SampleData.words

    // Filtered by search text (O(N) per keystroke – acceptable for 10 k items)
    private var filteredWords: [Word] {
        guard !searchText.isEmpty else { return words }
        return words.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }

    // Group words by their first uppercase character (A–Z); unknowns grouped under “#”.
    private var groupedWords: [Character: [Word]] {
        Dictionary(grouping: filteredWords) { word in
            word.text.uppercased().first ?? "#"
        }
    }

    // Sorted section keys so the list always appears A–Z.
    private var sortedLetters: [Character] { groupedWords.keys.sorted() }

    // MARK: – Body
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                // Main word list
                List {
                    ForEach(sortedLetters, id: \.self) { letter in
                        if let items = groupedWords[letter] {
                            Section(header: Text(String(letter))) {
                                ForEach(items) { word in
                                    NavigationLink {
                                        Text("123")
                                    } label: {
                                        Text(word.text)
                                    }

                                }
                            }
                            .id(letter) // Used by ScrollViewReader for fast‑scroll
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(                     // use the iOS 17 API
                    text:        $searchText,
                    isPresented: $isSearching,   // <- drives focus
                    prompt:      "Kelime ara"
                )
                .onAppear {                      // focus as soon as the view shows
                    isSearching = true
                }

                // Trailing vertical A–Z index
                AlphabetIndexView(letters: sortedLetters) { letter in
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(letter, anchor: .top)
                    }
                }
                .padding(.trailing, 8)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("\(words.count) word")
            }
        }
    }
}

/// Vertical index on the right‑hand side.
private struct AlphabetIndexView: View {
    let letters: [Character]
    var onSelect: (Character) -> Void

    var body: some View {
        VStack(spacing: 2) {
            ForEach(letters, id: \.self) { letter in
                Button(action: { onSelect(letter) }) {
                    Text(String(letter))
                        .font(.caption2)
                        .frame(width: 18, height: 18)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: – Demo seed (keep the array short here; replace with a 10 k‑word source for production)
private enum SampleData {
    static let words: [Word] = [
        "apple", "apricot", "avocado", "banana", "book", "cat", "cucumber", "dog", "elephant", "fig",
        "grape", "house", "ice", "jungle", "kiwi", "lemon", "mango", "notebook", "orange", "pear",
        "quilt", "raspberry", "strawberry", "tangerine", "umbrella", "violin", "watermelon", "xylophone", "yacht", "zebra"
    ].map(Word.init(text:))
}

#Preview {
    NavigationStack {
        DictionarySearchView()
    }
}
