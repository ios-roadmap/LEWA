//
//  Word.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import Foundation

struct Word: Codable, Identifiable, Hashable {
    var id: String { root }
    let root: String
    let meanings: [Meaning]
    let wordFamilies: [WordFamily]
    
    init(root: String, meanings: [Meaning], wordFamilies: [WordFamily]) {
        self.root = root
        self.meanings = meanings
        self.wordFamilies = wordFamilies
    }
    
    static var mock: Self {
        .init(
            root: "book",
            meanings: [
                .mock,
                .mock,
            ],
            wordFamilies: [
                .mock,
                .mock,
            ]
        )
    }
    
    static var mocks: [Self] {
        [
            .init(
                root: "Aoot1",

                meanings: [
                    .mock
                ],
                wordFamilies: [
                    .mock
                ]
            ),
            .init(
                root: "root1",
                meanings: [
                    .mock
                ],
                wordFamilies: [
                    .mock
                ]
            ),
            .init(
                root: "Zoot1",
                meanings: [
                    .mock
                ],
                wordFamilies: [
                    .mock
                ]
            )
        ]
    }
}

struct Meaning: Codable, Identifiable, Hashable {
    var id: UUID
    let sentence: String
//    let trSentence: String
    let definition: String
    let partOfSpeech: String
    
    init(id: UUID = UUID(), sentence: String, definition: String, partOfSpeech: String) {
        self.id = id
        self.sentence = sentence
        self.definition = definition
        self.partOfSpeech = partOfSpeech
    }
    
    // Custom Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.definition = try container.decode(String.self, forKey: .definition)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
    }
    
    static var mock: Self {
        .init(
            sentence: "She read an interesting book about ancient history.",
            definition: "A set of written or printed pages, usually bound with a cover.",
            partOfSpeech: ".noun"
        )
    }
}

struct WordFamily: Codable, Identifiable, Hashable {
    var id: UUID
    let word: String
    let partOfSpeech: String
    let sentence: String
    let definition: String
    
    init(id: UUID = UUID(), word: String, partOfSpeech: String, sentence: String, definition: String) {
        self.id = id
        self.word = word
        self.partOfSpeech = partOfSpeech
        self.sentence = sentence
        self.definition = definition
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        self.word = try container.decode(String.self, forKey: .word)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.definition = try container.decode(String.self, forKey: .definition)
    }

    static var mock: Self {
        .init(
            word: "word1",
            partOfSpeech: ".adjective",
            sentence: "sentence1",
            definition: "definition"
        )
    }
}

enum WordPartOfSpeech: String, Codable, CaseIterable, Identifiable, Hashable {
    case noun, verb, adjective, adverb, conjunction

    var id: String { self.rawValue }
}
