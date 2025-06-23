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
    var type: WordType
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
    var type: WordType // kaldır bunu gerek yok.
}

struct WordFamily: Codable, Hashable {
    var word: String
    var type: WordType
    var phonetics: [WordPhonetic]
    var definition: String
    var sentence: WordSentence
}

enum WordAccent: String, Codable {
    case uk
}

enum WordType: String, Codable, Hashable {
    case noun
    case verb
    case adjective
    case adverb
    case conjuction
}

enum WordTranslationsLanguage: String, Codable, Hashable {
    case tr
}
