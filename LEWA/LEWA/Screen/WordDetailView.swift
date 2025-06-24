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
                
                ForEach(entity.wordFamily, id: \.self) { family in
                    WordFamilyCard(family: family)
                }
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
            
            SynAntoTagsView(
                synonyms: meaning.synonyms,
                antonyms: meaning.antonyms
            )
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

struct WordFamilyCard: View {
    let family: WordFamily
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(family.word)
                    .font(.subheadline).fontWeight(.semibold)
                Image(systemName: "speaker.wave.2.fill")
                    .font(.subheadline).fontWeight(.semibold)
                
                Text(family.type.rawValue.capitalized)
                    .font(.caption)
            }
            
            Text("\(family.phonetics.first?.ipa ?? "")")
                .foregroundColor(.gray)
                .font(.caption2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(family.definition)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
                
                if !family.sentence.text.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "quote.opening")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(family.sentence.text)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
        )
    }
}

// Basit wrap-layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) -> CGSize {
        var size = CGSize.zero
        var rowHeight: CGFloat = 0
        
        let maxWidth = proposal.width ?? .infinity
        
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)
            if size.width + viewSize.width > maxWidth {
                size.width = 0
                size.height += rowHeight + spacing
                rowHeight = 0
            }
            rowHeight = max(rowHeight, viewSize.height)
            size.width += viewSize.width + spacing
        }
        size.height += rowHeight
        return size
    }
    
    func placeSubviews(in bounds: CGRect,
                       proposal: ProposedViewSize,
                       subviews: Subviews,
                       cache: inout ()) {
        var origin = bounds.origin
        var rowHeight: CGFloat = 0
        
        for view in subviews {
            let viewSize = view.sizeThatFits(.unspecified)
            if origin.x + viewSize.width > bounds.maxX {
                origin.x = bounds.minX
                origin.y += rowHeight + spacing
                rowHeight = 0
            }
            view.place(at: origin,
                       proposal: ProposedViewSize(viewSize))
            origin.x += viewSize.width + spacing
            rowHeight = max(rowHeight, viewSize.height)
        }
    }
}

// Tek bir bölüm (Synonyms / Antonyms)
struct TagSection: View {
    let title: String
    let tags: [WordSynonymAntonym]
    let titleColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(titleColor)
            
            FlowLayout(spacing: 8) {
                ForEach(tags, id: \.self) { word in
                    Text(word.word)
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(titleColor.opacity(0.15))
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct SynAntoTagsView: View {
    let synonyms: [WordSynonymAntonym]
    let antonyms: [WordSynonymAntonym]
    
    var body: some View {
        ScrollView { // SORUN VAR KALDIRMAK İSTİYORUM AMA ŞİMDİLİK ÖNEMİ YOK
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    TagSection(title: "Synonyms",
                               tags: synonyms,
                               titleColor: .blue)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                    
                    Divider()
                        .frame(width: 1)
                        .padding(.horizontal, 12)
                    
                    TagSection(title: "Antonyms",
                               tags: antonyms,
                               titleColor: .red)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
            }
        }
    }
}
