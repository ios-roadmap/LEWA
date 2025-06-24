//
//  WordEntity.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 22.06.2025.
//

import Foundation

struct WordEntity: Codable {
    var id: String
    var word: String
    var phonetics: [WordPhonetic]
    var meanings: [WordMeaning]
    var wordFamily: [WordFamily]
    
    enum CodingKeys: String, CodingKey {
        case id
        case word
        case phonetics
        case meanings
        case wordFamily = "word_family"
    }
    
    init(
        id: String,
        word: String,
        phonetics: [WordPhonetic],
        meanings: [WordMeaning],
        wordFamily: [WordFamily]
    ) {
        self.id = id
        self.word = word
        self.phonetics = phonetics
        self.meanings = meanings
        self.wordFamily = wordFamily
    }
    
    static var mock: Self {
        .init(
            id: "",
            word: "abundant",
            phonetics: [
                .init(
                    accent: .uk,
                    ipa: "əˈbʌndənt",
                    audio: ""
                )
            ],
            meanings: [
                .init(
                    partOfSpeech: .adjective,
                    definition: "Describes someone or something that exists in large quantities; more than enough.",
                    image: "",
                    sentence: .init(
                        text: "Natural resources are abundant in this region.",
                        audio: "",
                        translations: [
                            .init(
                                lang: .turkish,
                                text: "Bu bölgede doğal kaynaklar bol miktarda bulunmaktadır."
                            )
                        ]
                    ),
                    synonyms: [
                        .init(id: "", word: "plentiful", type: .adjective),
                        .init(id: "", word: "plentiful2", type: .adjective),
                        .init(id: "", word: "plentiful3", type: .adjective),
                    ],
                    antonyms: [
                        .init(id: "", word: "q", type: .adjective),
                        .init(id: "", word: "qw", type: .adjective),
                        .init(id: "", word: "qwe", type: .adjective),
                    ]
                ),
                .init(
                    partOfSpeech: .noun,
                    definition: "Noun 2",
                    image: "",
                    sentence: .init(
                        text: "Sentence 2 Sentence 2 Sentence 2 Sentence 2 Sentence 2",
                        audio: "",
                        translations: [
                            .init(
                                lang: .turkish,
                                text: "Cümle 2 Cümle 2 Cümle 2 Cümle 2 Cümle 2"
                            )
                        ]
                    ),
                    synonyms: [
                        .init(id: "", word: "es anlam", type: .adjective),
                        .init(id: "", word: "es anlam2", type: .adjective),
                        .init(id: "", word: "es anlam3", type: .adjective),
                        .init(id: "", word: "es anlam4", type: .adjective),
                        .init(id: "", word: "es anlam5", type: .adjective),
                        .init(id: "", word: "es anlam6", type: .adjective),
                        .init(id: "", word: "es anlam7", type: .adjective),
                    ],
                    antonyms: [
                        .init(id: "", word: "zit anlam", type: .adjective),
                        .init(id: "", word: "zit anlam1", type: .adjective),
                        .init(id: "", word: "zit anlam2", type: .adjective),
                        .init(id: "", word: "zit anlam3", type: .adjective),
                        .init(id: "", word: "zit anlam4", type: .adjective),
                    ]
                ),
            ],
            wordFamily: [
                .init(
                    word: "abundance",
                    type: .noun,
                    phonetics: [
                        .init(
                            accent: .uk,
                            ipa: "əˈbʌndəns",
                            audio: ""
                        )
                    ],
                    definition: "A very large quantity of something.",
                    sentence: .init(
                        text: "There was an abundance of food at the festival.",
                        audio: "",
                        translations: [
                            .init(
                                lang: .turkish,
                                text: "Festivalde bol miktarda yiyecek vardı."
                            )
                        ]
                    )
                ),
                .init(
                    word: "abundantly",
                    type: .adverb,
                    phonetics: [
                        .init(
                            accent: .uk,
                            ipa: "əˈbʌndəntli",
                            audio: ""
                        )
                    ],
                    definition: "In a way that is more than enough; in large quantities.",
                    sentence: .init(
                        text: "The evidence is abundantly clear.",
                        audio: "",
                        translations: [
                            .init(
                                lang: .turkish,
                                text: "Kanıtlar fazlasıyla açıktır."
                            )
                        ]
                    )
                )
            ]
        )
    }
}
