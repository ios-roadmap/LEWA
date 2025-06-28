//
//  CardFace.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct CardFace: View {
    let text: String
    let color: Color
    let showSpeaker: Bool
    
    init(text: String, color: Color, showSpeaker: Bool = false) {
        self.text = text
        self.color = color
        self.showSpeaker = showSpeaker
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(.thinMaterial)
            
            HStack(spacing: 8) {
                if showSpeaker {
                    SpeakerButton(text: text)
                }
                
                Text(text)
                    .foregroundStyle(color)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 12)
        }
    }
}


#Preview {
    CardFace(text: "Hello, World!", color: .blue)
}
