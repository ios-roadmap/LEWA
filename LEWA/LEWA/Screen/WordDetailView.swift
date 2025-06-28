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

    
    @State private var showTurkish: Bool = false
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            List {
                HStack {
                    Text(word.root.capitalized)
                        .font(.largeTitle)
                    SpeakerButton(text: word.root)
                }
                .fontWeight(.bold)
                .removeListRowFormatting()
                
                Section {
                    CarouselView(items: word.meanings, onSelectionChange: {
                        showTurkish = false
                    }) { meaning in
                        MeaningView(meaning: meaning, showTurkish: $showTurkish)
                            .padding()
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listRowSeparator(.hidden)
                    .removeListRowFormatting()
                } header: {
                    Text("Meanings").bold().font(.headline).foregroundStyle(.red)
                }
                
                if !word.forms.isEmpty {
                    Section {
                        ScrollView(.horizontal) {
                            HStack {
                                Text
                                    .commaSeparated(word.forms)
                                    .font(.callout)
                                    .foregroundColor(.primary)
                                    .padding(.vertical, 4)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    } header: {
                        Text("Forms").bold().font(.headline).foregroundStyle(.red)
                    }
                }
                
                if !word.wordFamilies.isEmpty {
                    Section {
                        ForEach(word.wordFamilies) { family in
                            WordFamilyCard(family: family)
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
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: toggleStar) {
                    Image(systemName: isStarred ? "star.fill" : "star")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: toggleShowTurkish) {
                    Image(systemName: "arrow.2.squarepath")
                }
            }
        }
    }
    
    private func toggleShowTurkish() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showTurkish.toggle()
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
