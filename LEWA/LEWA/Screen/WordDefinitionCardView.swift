//
//  WordDefinitionCardView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 1.07.2025.
//

import SwiftUI

struct WordDefinitionCardView: View {
    let definition: any DefinitionRepresentable

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title: Word and its part of speech
            HStack {
                if let wordFamily = definition as? WordFamily {
                    Text(wordFamily.word)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SpeakerButton(text: wordFamily.word)
                        .font(.caption)
                }
                
                Text("(\(definition.partOfSpeech))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(0)
            }
            
            Text(definition.definition)
                .font(.body)
                .foregroundColor(.primary)
            
            Group {
                HStack(spacing: 8) {
                    SpeakerButton(text: definition.sentence)
                    
                    Text("\(definition.sentence)")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        
    }
}

#Preview("WordFamily") {
    ZStack {
        Color.yellow.ignoresSafeArea()
        WordDefinitionCardView(definition: WordFamily.mock)
    }
}

#Preview("Meaning") {
    ZStack {
        Color.green.ignoresSafeArea()
        WordDefinitionCardView(definition: Meaning.mock)
    }
}
