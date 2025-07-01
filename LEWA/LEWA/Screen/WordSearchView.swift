//
//  WordSearchView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import SwiftUI

struct WordSearchView: View {
    @State private var searchText = ""
    @State private var debouncedSearchText = ""
    @State private var isSearching = true
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var showRootsOnly = true

    let words: [Word]

    private static var printedDisplays = Set<String>()
    private var allWords: [(display: String, word: Word, root: String, isRoot: Bool, partOfSpeech: String)] {
        // 1) Build flat list of roots + family words including partOfSpeech
        let combined = words.flatMap { word -> [(String, Word, String, Bool, String)] in
            var items: [(String, Word, String, Bool, String)] = []
            let rootPOS = word.meanings.first?.partOfSpeech ?? ""
            items.append((word.root, word, word.root, true, rootPOS))
            word.wordFamilies.forEach { family in
                items.append((family.word, word, word.root, false, family.partOfSpeech))
            }
            return items
        }

        // 2) Detect duplicates in `display`
        let groupedByDisplay = Dictionary(grouping: combined, by: { $0.0 })
        let duplicates = groupedByDisplay.filter { $0.value.count > 1 }

        // 3) Handle duplicates
        for (display, entries) in duplicates {
            let posSet = Set(entries.map { $0.4 })
            if posSet.count == 1 {
                fatalError("WordSearchView - duplicate display keys with identical partOfSpeech found: [\(display)]")
            } else if !WordSearchView.printedDisplays.contains(display) {
                WordSearchView.printedDisplays.insert(display)
                print("Duplicate display with different partOfSpeech for key: \(display)")
            }
        }

        // 4) Apply roots-only filter if needed
        let filtered = showRootsOnly
            ? combined.filter { $0.3 }
            : combined

        return filtered.map { (display: $0.0, word: $0.1, root: $0.2, isRoot: $0.3, partOfSpeech: $0.4) }
    }


    private var filteredWords: [(display: String, word: Word, root: String, isRoot: Bool, partOfSpeech: String)] {
        guard !debouncedSearchText.isEmpty else { return allWords }
        return allWords.filter { $0.display.localizedCaseInsensitiveContains(debouncedSearchText) }
    }

    private var grouped: [Character: [(display: String, word: Word, root: String, isRoot: Bool, partOfSpeech: String)]] {
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
                .onAppear { isSearching = false }
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
                Text("Roots: \(words.count)")
            }
            ToolbarItem(placement: .topBarLeading) {
                Text("All words: \(words.flatMap { [$0.root] + $0.wordFamilies.map(\ .word) }.count)")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showRootsOnly.toggle()
                }) {
                    Text(showRootsOnly ? "Show All Words" : "Show Roots Only")
                }
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
        wordFamilies.first(where: { $0.word == word })?.id
    }
}
