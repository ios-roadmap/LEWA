//
//  WordAttributes.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 22.06.2025.
//

import Foundation

struct WordPhonetic: Codable, Hashable {
    var accent: WordAccent
    var ipa: String
    var audio: String
}

struct WordMeaning: Codable, Hashable {
    var partOfSpeech: WordPartOfSpeech
    var definition: String
    var image: String
    var sentence: WordSentence
    var synonyms: [WordSynonymAntonym]
    var antonyms: [WordSynonymAntonym]
}

struct WordSentence: Codable, Hashable {
    var text: String
    var audio: String
    var translations: [WordTranslation]
}

struct WordTranslation: Codable, Hashable {
    var lang: WordTranslationsLanguage
    var text: String
}

struct WordSynonymAntonym: Codable, Hashable {
    var id: String
    var word: String
    var type: WordPartOfSpeech
}

struct WordFamily: Codable, Hashable {
    var word: String
    var type: WordPartOfSpeech
    var phonetics: [WordPhonetic]
    var definition: String
    var sentence: WordSentence
}

enum WordAccent: String, Codable {
    case uk
}

enum WordPartOfSpeech: String, Codable, Hashable {
    case noun
    case verb
    case adjective
    case adverb
    case conjuction
}

enum WordTranslationsLanguage: String, Codable, Hashable {
    case turkish
    
    var code: String {
        switch self {
        case .turkish: return "tr"
        }
    }
}

enum WordRelationType: String {
    case synonym = "Synonym"
    case antonym = "Antonym"
}

enum EnglishAccent: String, CaseIterable, Identifiable {
    case british   = "en-GB"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .british:      return "British English"
        }
    }
}
