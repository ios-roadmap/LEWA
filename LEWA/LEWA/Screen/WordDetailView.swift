//
//  WordDetailView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI
import SwiftData

struct WordDetailView: View {
    let word: Word
    let selectedFamilyId: UUID?
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var isStarred: Bool = false
    @State private var starredWord: StarredWord? = nil
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            List {
                HStack {
                    Text(word.root.capitalized)
                        .font(.largeTitle)
                    SpeakerButton(text: word.root)
                        .font(.headline)
                }
                .fontWeight(.bold)
                .removeListRowFormatting()
                
                Section {
                    ForEach(word.meanings) { meaning in
                        WordDefinitionCardView(definition: meaning)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                } header: {
                    Text("Meanings").bold().font(.headline).foregroundStyle(.red)
                }
                
                if !word.wordFamilies.isEmpty {
                    Section {
                        ForEach(word.wordFamilies) { family in
                            WordDefinitionCardView(definition: family)
                                .id(family.id)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    } header: {
                        Text("Word Family").bold().font(.headline).foregroundStyle(.red)
                    }
                }
            }
            .onAppear {
                if let id = selectedFamilyId {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
            }
            .onAppear(perform: loadStarredState)
        })
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {      // iOS/iPadOS
                Button(action: toggleStar) {
                    Image(systemName: isStarred ? "star.fill" : "star")
                }
            }
            #elseif os(macOS)
            ToolbarItem(placement: .primaryAction) {          // macOS 13+
                Button(action: toggleStar) {
                    Image(systemName: isStarred ? "star.fill" : "star")
                }
            }
            #endif
        }

    }
    
    private func loadStarredState() {
        let wordID = word.id // Veya word.root, senin id’in o zaten
        let fetchDescriptor = FetchDescriptor<StarredWord>(predicate: #Predicate<StarredWord> { starred in
            starred.id == wordID
        })
        if let result = try? modelContext.fetch(fetchDescriptor).first {
            self.starredWord = result
            self.isStarred = result.isStarred
        } else {
            self.starredWord = nil
            self.isStarred = false
        }
    }
    
    
    private func toggleStar() {
        if let starred = starredWord {
            starred.isStarred.toggle()
            self.isStarred = starred.isStarred
        } else {
            let newStarred = StarredWord(id: word.id, isStarred: true)
            modelContext.insert(newStarred)
            self.starredWord = newStarred
            self.isStarred = true
        }
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        WordDetailView(word: .mock, selectedFamilyId: nil)
    }
}
