//
//  SpeakerButton.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 28.06.2025.
//


import SwiftUI

struct SpeakerButton: View {
    let text: String
    
    var body: some View {
        Image(systemName: "speaker.wave.3")
            .foregroundStyle(Color.gray)
            .onTapGesture {
                VoiceManager.shared.speak(word: text)
            }
    }
}
