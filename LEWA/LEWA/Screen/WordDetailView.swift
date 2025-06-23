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

struct WordDetailView: View {
    
    let entity: WordEntity = .mock
    
    var meanings: [WordMeaning] {
        entity.meanings
    }
    
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        List {
            header
                .padding(.bottom, 16)
            
            meaningsView
            
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                Text(meaning.type.rawValue)
                    .font(.subheadline).bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .clipShape(Capsule())
            
            HStack(alignment: .top, spacing: 12) {
                Text(meaning.definition)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)  // <<< önemli
                    .layoutPriority(1)
                
                ImageLoaderView(urlString: Constants.randomImage)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            HStack {
                Image(systemName: "speaker.wave.3.fill")
                Text(meaning.sentence.text)
            }
            .foregroundStyle(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
