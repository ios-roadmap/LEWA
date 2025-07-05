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
    
    init(root: String, meanings: [Meaning]) {
        self.root = root
        self.meanings = meanings
    }
    
    static var mock: Self {
        .init(
            root: "book",
            meanings: [
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
                ]
            ),
            .init(
                root: "root1",
                meanings: [
                    .mock
                ]
            ),
            .init(
                root: "Zoot1",
                meanings: [
                    .mock
                ]
            )
        ]
    }
}

struct Meaning: Identifiable, Codable, Hashable {
    var id: UUID
    let word: String
    let sentence: String
    let definition: String
    let partOfSpeech: String

    init(
        id: UUID = UUID(),
        word: String,
        sentence: String,
        definition: String,
        partOfSpeech: String
    ) {
        self.id = id
        self.word = word
        self.sentence = sentence
        self.definition = definition
        self.partOfSpeech = partOfSpeech
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID()
        self.word = try container.decode(String.self, forKey: .word)
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.definition = try container.decode(String.self, forKey: .definition)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
    }

    static var mock: Self {
        .init(
            word: "book",
            sentence: "She read an interesting book about ancient history.",
            definition: "A set of written or printed pages, usually bound with a cover.",
            partOfSpeech: ".noun"
        )
    }
}

enum WordPartOfSpeech: String, Codable, CaseIterable, Identifiable, Hashable {
    case noun, verb, adjective, adverb, conjunction

    var id: String { self.rawValue }
}
