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
    @Query private var starredRecords: [StarredWord]
    
    @State private var showTurkish: Bool = false
    private var isStarred: Bool { starredRecords.first?.isStarred ?? false }
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            List {
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
            .onAppear {
                if let id = selectedFamilyId {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
            }
        })
        .navigationTitle(word.root.capitalized)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: toggleStar) {
                    Image(systemName: isStarred ? "star.fill" : "star")
                        .font(.title)
                }
            }
        }
    }
    
    private func toggleStar() {
        if let record = starredRecords.first {
            record.isStarred.toggle()            // updates automatically
        } else {
            modelContext.insert(StarredWord(id: word.id, isStarred: true))
        }
        try? modelContext.save()                 // explicit save is optional but safe
    }
}

#Preview {
    NavigationStack {
        WordDetailView(word: .mock, selectedFamilyId: nil)
    }
}
