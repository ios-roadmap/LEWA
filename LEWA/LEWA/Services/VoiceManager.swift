//
//  VoiceManager.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import AVFAudio

class VoiceManager {
    
    static func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: EnglishAccent.british.id)
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
