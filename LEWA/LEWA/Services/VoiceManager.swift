//
//  VoiceManager.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import AVFAudio

class VoiceManager {
    static func speak(word: String) {
        let voiceIdentifiers = [
            "com.apple.ttsbundle.Daniel-compact", // Erkek
            "com.apple.ttsbundle.Kate-compact"    // Kadın
        ]
        
        let randomIndex = Int.random(in: 0..<voiceIdentifiers.count)
        let chosenVoiceId = voiceIdentifiers[randomIndex]
        
        let utterance = AVSpeechUtterance(string: word)
        if let voice = AVSpeechSynthesisVoice(identifier: chosenVoiceId) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        }
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
