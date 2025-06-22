//
//  WordDetailView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 22.06.2025.
//

import SwiftUI
import AVFoundation

struct WordDetailView: View {
    
    let entity: WordEntity = .mock
    
    var body: some View {
        List {
            header
            
            ForEach(entity.meanings, id: \.self) { meaning in
                MeaningCardView(meaning: meaning)
                    .removeListRowFormatting()
                    .listRowSeparator(.hidden)
                    .padding(.top, 16)
            }
            
            synonym antonym vs. eklenecek buraya
            word family eklenecek
            UI design tamamlanacak
            JSON veriler gözden geçirilecek
            amaç tamamen word detay ekranı yapmak olacak
            mock veri tamamlanınca Sqlflite eklenecek
            sonra tüm exceldekiler buraya aktarılacak sql ler ile
            akabinde flashcard oluşturulacak
            sözlükten flashcard'lar seçilebilecek ve bireysel olarak çalışma sağlanacak
            kategori gibi user kendi oluşturabiliyor olması lazım
            bende wallstreet, breaking bad vs. ayırarak gidicem burada
            sonra her bir word un reading listening speaking ve writing yıldızlamaları eklenecek ama bu swift data ile yapılacak ya da firebase. ya da ikisi ortak
        }
    }
    
    private func speak(word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: EnglishAccent.british.id)
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
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
                        speak(word: entity.word)
                    }
                    
            }
        }
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

struct MeaningCardView: View {
    let meaning: WordMeaning

    @State private var isSpeaking = false

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // İçerik
            VStack(alignment: .leading, spacing: 10) {
                // Kelime türü badge
             

                // Tanım
                HStack {
                    VStack(alignment: .leading) {
                        Text(meaning.type.rawValue.capitalized)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 4.5)
                            .background(badgeColor(for: WordType(rawValue: meaning.type.rawValue) ?? .noun))
                            .clipShape(Capsule())
                        
                        Text(meaning.definition)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundColor(.primary)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    ImageLoaderView(urlString: Constants.randomImage)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .shadow(radius: 1.5, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(Color(.separator), lineWidth: 0.4)
                        )
                    
                }
                

                // Örnek cümle + ses
                HStack(spacing: 8) {
                    Button {
                        speak(text: meaning.sentence.text)
                    } label: {
                        Image(systemName: isSpeaking ? "speaker.wave.2.fill" : "speaker.wave.3.fill")
                            .font(.title3)
                            .foregroundColor(isSpeaking ? .accentColor : .secondary)
                            .scaleEffect(isSpeaking ? 1.1 : 1)
                            .animation(.easeOut(duration: 0.25), value: isSpeaking)
                    }
                    .buttonStyle(.plain)

                    Text(meaning.sentence.text)
                        .font(.body.italic())
                        .foregroundColor(.secondary)
                }

                // Türkçe çeviri (varsa)
                if let translation = meaning.sentence.translations.first?.text {
                    Text(translation)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, -4)
                }
            }
            .padding(.vertical, 2)

            Spacer(minLength: 0)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 3)
        .padding(.horizontal)
    }

    private func badgeColor(for type: WordType) -> Color {
        switch type {
        case .adjective: return .blue
        case .noun:      return .green
        case .verb:      return .orange
        default:         return .gray
        }
    }

    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        isSpeaking = true
        synthesizer.speak(utterance)
        // Basit bir şekilde, konuşma süresi kadar animasyonu aktif bırakıyoruz
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(text.split(separator: " ").count) * 0.32) {
            isSpeaking = false
        }
    }
}
