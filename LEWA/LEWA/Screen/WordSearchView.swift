//
//  WordSearchView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import SwiftUI

struct WordSearchView: View {
    // MARK: – State & input
    @State private var searchText = ""
    @State private var debouncedSearchText = ""
    @State private var isSearching = false
    @State private var debounceWorkItem: DispatchWorkItem?
    
    // stores the one-time computation
    @State private var allWordsList: [(display: String, word: Word, root: String, partOfSpeech: String)] = []
    
    let words: [Word]
    
    // MARK: – One-time flatten + duplicate-check
    private func loadAllWordsOnce() {
        guard allWordsList.isEmpty else { return }
        
        var result: [(display: String, word: Word, root: String, partOfSpeech: String)] = []
        var seenRoots    = [String: String]()  // display → first root
        var warned       = Set<String>()       // displays already warned
        
        for word in words {
            for meaning in word.meanings {
                let display = meaning.word
                let root    = word.root
                
                if let firstRoot = seenRoots[display] {
                    if !warned.contains(display) {
                        let rootsList = (firstRoot == root)
                            ? firstRoot
                            : "\(firstRoot), \(root)"
                        print("Duplicate display '\(display)' for roots: \(rootsList)")
                        warned.insert(display)
                    }
                } else {
                    seenRoots[display] = root
                }
                
                result.append((display, word, root, meaning.partOfSpeech))
            }
        }
        
        allWordsList = result
    }
    
    // MARK: – Filtering & grouping
    private var filteredWords: [(display: String, word: Word, root: String, partOfSpeech: String)] {
        guard !debouncedSearchText.isEmpty else { return allWordsList }
        return allWordsList.filter { $0.display.localizedCaseInsensitiveContains(debouncedSearchText) }
    }

    private var grouped: [Character: [(display: String, word: Word, root: String, partOfSpeech: String)]] {
        Dictionary(grouping: filteredWords) { $0.display.first ?? "#" }
    }

    private var sortedLetters: [Character] { grouped.keys.sorted() }

    // MARK: – View body
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .trailing) {
                List {
                    ForEach(sortedLetters, id: \.self) { letter in
                        Section(header: Text(String(letter))) {
                            ForEach(grouped[letter] ?? [], id: \.display) { item in
                                NavigationLink(
                                    destination: WordDetailView(
                                        word: item.word,
                                        selectedFamilyId: item.word.familyId(forWord: item.display)
                                    )
                                ) {
                                    VStack(alignment: .leading) {
                                        Text(item.display)
                                        Text(item.partOfSpeech)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .id(letter)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, isPresented: $isSearching, prompt: "Search words")
                .onAppear {
                    loadAllWordsOnce()
                    isSearching = false
                }
                .onChange(of: searchText) { _, newValue in
                    debounceWorkItem?.cancel()
                    let workItem = DispatchWorkItem { debouncedSearchText = newValue }
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
    #if os(iOS)
            ToolbarItem(placement: .topBarLeading) {
                Text("Meanings: \(allWordsList.count)")
            }
    #elseif os(macOS)
            ToolbarItem(placement: .principal) {
                Text("Meanings: \(allWordsList.count)")
                    .font(.headline)
            }
    #endif
        }
    }
}

// MARK: – AlphabetIndexView
private struct AlphabetIndexView: View {
    let letters: [Character]
    var onSelect: (Character) -> Void

    var body: some View {
        VStack(spacing: 2) {
            ForEach(letters, id: \.self) { letter in
                Button(String(letter)) { onSelect(letter) }
                    .font(.caption2)
                    .frame(width: 18, height: 18)
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
            }
        }
    }
}

// MARK: – Word extension
extension Word {
    func familyId(forWord word: String) -> UUID? {
        meanings.first(where: { $0.word == word })?.id
    }
}
