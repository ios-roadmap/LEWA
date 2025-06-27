//
//  WordStarredView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI
import SwiftData

struct WordStarredView: View {
    @EnvironmentObject private var store: WordsStore
    @Query(filter: #Predicate<StarredWord> { $0.isStarred == true })
    private var starredWords: [StarredWord]


    var body: some View {
        List(starredWords) { star in
            if let word = store.word(forID: star.id) {
                NavigationLink {
                    WordDetailView(word: word)
                } label: {
                    Text(word.root)
                }

            }
        }
        .navigationTitle("Starred Words")
    }
}
