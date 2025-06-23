//
//  WordDetailView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 22.06.2025.
//

import SwiftUI
import AVFoundation

//-> synonym antonym vs. eklenecek buraya
//-> word family eklenecek
//-> UI design tamamlanacak
//-> JSON veriler gözden geçirilecek
//-> amaç tamamen word detay ekranı yapmak olacak
//-> mock veri tamamlanınca Sqlflite eklenecek
//-> sonra tüm exceldekiler buraya aktarılacak sql ler ile
//-> akabinde flashcard oluşturulacak
//-> sözlükten flashcard'lar seçilebilecek ve bireysel olarak çalışma sağlanacak
//-> kategori gibi user kendi oluşturabiliyor olması lazım
//-> bende wallstreet, breaking bad vs. ayırarak gidicem burada
//-> sonra her bir word un reading listening speaking ve writing yıldızlamaları eklenecek ama bu swift data ile yapılacak ya da firebase. ya da ikisi ortak
//-> Burada aksan değiştirildiğinde ilgili aksanın phonetic bilgisi otomatik değişecek telefonda. Ama şuanlık sadece ingilizce olacak. ileride bunu ayarlarım geleceğe not.
//-> 3 tab view olacak proje. ilk tab sözlük. ikinci tab stars. üçüncü tab flashcards.

struct WordDetailView: View {
    
    let entity: WordEntity = .mock
    
    var meanings: [WordMeaning] {
        entity.meanings
    }
    
    
    
    var body: some View {
        List {
            header
                .padding(.bottom, 16)
            
            meaningsView
                .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                Text("Word Family")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                WordFamilyView(families: entity.wordFamily)
            }
            .removeListRowFormatting()
            .listRowSeparator(.hidden)
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text(entity.word)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            HStack {
                Text("🇬🇧")
                Text(entity.phonetics.first?.ipa ?? "")
                Image(systemName: "speaker.wave.3.fill")
                    .onTapGesture {
                        VoiceManager.speak(word: entity.word)
                    }
                    
            }
        }
        .removeListRowFormatting()
        .listRowSeparator(.hidden)
    }
    
    private var meaningsView: some View {
        CarouselView(
            items: meanings,
            content: { meaning in
                MeaningCardView(meaning: meaning)
            }
        )
        .removeListRowFormatting()
        .listRowSeparator(.hidden)
    }
}

#Preview {
    NavigationStack {
        WordDetailView()
    }
}

enum EnglishAccent: String, CaseIterable, Identifiable {
    case british   = "en-GB"
    case american  = "en-US"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .british:      return "British English"
        case .american:     return "American English"
        }
    }
}

class VoiceManager {
    
    static func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: EnglishAccent.british.id)
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct MeaningCardView: View {
    let meaning: WordMeaning
    
    @State private var selectedType: WordType2 = .synonym
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading) {
                    Text(meaning.type.rawValue)
                        .font(.subheadline).bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    
                    Text(meaning.definition)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)  // <<< önemli
                        .layoutPriority(1)
                }
                
                
                Spacer()
                
                ImageLoaderView(urlString: Constants.randomImage)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            HStack {
                Image(systemName: "speaker.wave.3.fill")
                Text(meaning.sentence.text)
            }
            .font(.subheadline)
            .foregroundStyle(.gray)
            
            HStack() {
                ForEach([WordType2.synonym, WordType2.antonym], id: \.self) { type in
                    Button(action: {
                        selectedType = type
                    }) {
                        Text(type.rawValue)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .foregroundColor(selectedType != type ? .gray : .blue)
                            .cornerRadius(16)
                            .animation(.easeInOut(duration: 0.15), value: selectedType)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(selectedType == .synonym ? meaning.synonyms : meaning.antonyms, id: \.self) { word in
                        Text(word.word)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}
enum WordType2: String {
    case synonym = "Synonym"
    case antonym = "Antonym"
}

import SwiftUI


struct WordFamilyView: View {
    let families: [WordFamily]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Word Family")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Kartlar
            ForEach(families, id: \.self) { family in
                WordFamilyCard(family: family)
            }
        }
    }
}

struct WordFamilyCard: View {
    let family: WordFamily
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Sol: Tip etiketi (örn. Verb)
            Text(family.type.rawValue.capitalized)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(
                    Capsule().fill(.green)
                )
                .frame(minWidth: 64)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(family.word)
                        .font(.subheadline).fontWeight(.semibold)
                    Text("/\(family.phonetics.first?.ipa ?? "")/")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                Text(family.definition)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Örnek cümle (isteğe bağlı)
                if !family.sentence.text.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "quote.opening")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(family.sentence.text)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            // Ses butonu
            Button {
                // Play audio
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6))
        )
    }
}
