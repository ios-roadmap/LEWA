//
//  MeaningView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct MeaningView: View {
    let meaning: Meaning
    @Binding var showTurkish: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(meaning.partOfSpeech)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Capsule())
                Text(meaning.definition)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            FlipCardView(
                english: meaning.sentence,
                turkish: meaning.trSentence,
                showTurkish: $showTurkish
            )
            .frame(height: 100)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color(.systemBackground).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(radius: 1, x: 0, y: 1)
    }
}

#Preview {
    MeaningView(meaning: .mock, showTurkish: .constant(false))
}
