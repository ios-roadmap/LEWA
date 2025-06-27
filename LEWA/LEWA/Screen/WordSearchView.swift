//
//  WordSearchView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import SwiftUI

// --- ASIL GÖRÜNÜM ---
struct WordSearchView: View {
    @State private var searchText = ""
    @State private var debouncedSearchText = ""
    @State private var isSearching = false
    @State private var debounceWorkItem: DispatchWorkItem?

    let words: [Word]

    // root ve families tek listede: (görünen kelime, Word, root)
    private var allWords: [(display: String, word: Word, root: String, isRoot: Bool)] {
        words.flatMap { word in
            [(word.root.capitalized, word, word.root.capitalized, true)]
            +
            word.wordFamilies.map { ($0.word.capitalized, word, word.root.capitalized, false) }
        }
    }

    private var filteredWords: [(display: String, word: Word, root: String, isRoot: Bool)] {
        guard !debouncedSearchText.isEmpty else { return allWords }
        return allWords.filter { $0.display.localizedCaseInsensitiveContains(debouncedSearchText) }
    }

    private var grouped: [Character: [(display: String, word: Word, root: String, isRoot: Bool)]] {
        Dictionary(grouping: filteredWords) { $0.display.first ?? "#" }
    }

    private var sortedLetters: [Character] { grouped.keys.sorted() }

    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                List {
                    ForEach(sortedLetters, id: \.self) { letter in
                        if let items = grouped[letter] {
                            Section(header: Text(String(letter))) {
                                ForEach(items, id: \.display) { item in
                                    NavigationLink(
                                        destination: WordDetailView(
                                            word: item.word,
                                            selectedFamilyId: item.isRoot ? nil : item.word.familyId(forWord: item.display)

                                        )
                                    ) {
                                        HStack {
                                            Text(item.display)
                                            if !item.isRoot {
                                                Text("• \(item.root)")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                    .padding(.leading, 4)
                                            }
                                        }
                                    }
                                }

                            }
                            .id(letter)
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(
                    text: $searchText,
                    isPresented: $isSearching,
                    prompt: "Search words"
                )
                .onAppear { isSearching = true }
                .onChange(of: searchText) { _, newValue in
                    debounceWorkItem?.cancel()
                    let workItem = DispatchWorkItem {
                        debouncedSearchText = newValue
                    }
                    debounceWorkItem = workItem
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
                }

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
                Text("\(allWords.count) words")
            }
        }
    }
}

// MARK: – AlphabetIndexView
/// Vertical fast‑scroll index on the right‑hand side.
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

// MARK: – Previews (using minimal mock data)
#Preview {
    NavigationStack {
        WordSearchView(words: Word.mocks)
    }
}
extension Word {
    func familyId(forWord word: String) -> UUID? {
        wordFamilies.first(where: { $0.word.capitalized == word })?.id
    }
}
