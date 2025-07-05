//
//  WordDefinitionCardView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 1.07.2025.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif


struct WordDefinitionCardView: View {
    let definition: any DefinitionRepresentable

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title: Word and its part of speech
            HStack {
                if let wordFamily = definition as? WordFamily {
                    Text(wordFamily.word)
                        .font(.headline)
                    
                    SpeakerButton(text: wordFamily.word)
                        .font(.caption)
                }
                
                Text("(\(definition.partOfSpeech))")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(0)
            }
            .foregroundStyle(Color.gray)
            
            Text(definition.definition)
                .font(.body)
                .fontWeight(.semibold)
            
            Group {
                HStack(spacing: 8) {
                    SpeakerButton(text: definition.sentence)
                    
                    Text("\(definition.sentence)")
                        .font(.callout)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.5)) //let color = Color(UIColor.systemBackground)
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
