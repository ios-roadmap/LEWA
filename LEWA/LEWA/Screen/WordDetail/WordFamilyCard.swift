//
//  WordFamilyCard.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct WordFamilyCard: View {
    let family: WordFamily
    @State private var showEnglishSentence = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title: Word and its part of speech
            HStack {
                Text(family.word)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("(\(family.partOfSpeech))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            // Definition
            Text(family.definition)
                .font(.body)
                .foregroundColor(.primary)
            
            // Sentence toggle
            Group {
                if showEnglishSentence {
                    HStack(spacing: 8) {
                        SpeakerButton(text: family.sentence)
                        
                        Text("\(family.sentence)")
                            .font(.callout)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showEnglishSentence = false
                            }
                    }
                } else {
                    Text("\(family.trSentence)")
                        .font(.callout)
                        .foregroundColor(.green)
                        .onTapGesture {
                            showEnglishSentence = true
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        
    }
}

#Preview {
    WordFamilyCard(family: .mock)
}
