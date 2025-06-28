//
//  VoiceManager.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import AVFAudio

class VoiceManager {
    static let shared = VoiceManager()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
}
