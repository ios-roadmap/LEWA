//
//  FlipCardView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct FlipCardView: View {
    let english: String
    let turkish: String

    @Binding var showTurkish: Bool

    var body: some View {
        ZStack {
            CardFace(text: english, color: .blue, showSpeaker: true)
                .opacity(showTurkish ? 0.0 : 1.0)
                .rotation3DEffect(.degrees(showTurkish ? 180 : 0), axis: (x:0, y:1, z:0))
            CardFace(text: turkish, color: .black)
                .opacity(showTurkish ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(showTurkish ? 0 : -180), axis: (x:0, y:1, z:0))
        }
        .cornerRadius(14)
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showTurkish.toggle()
            }
        }
    }
}

#Preview {
    let mock = Meaning.mock
    FlipCardView(
        english: mock.sentence,
        turkish: mock.trSentence,
        showTurkish: .constant(false)
    )
}
