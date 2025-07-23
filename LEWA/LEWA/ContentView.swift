//
//  ContentView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 23.07.2025.
//

//import SwiftUI
//
//struct ContentView: View {
//    
//    @State var model = LMModel()
//    
//    var body: some View {
//        ZStack {
//            ScrollView {
//                LazyVStack(alignment: .leading, spacing: 12) {
//                    ForEach(model.session.transcript) { entry in
//                        Group {
//                            switch entry {
//                            case .prompt(let prompt):
//                                MessageView(segments: prompt.segments, isUser: true)
//                                    .transition(.offset(y: 500))
//                                    .padding(.trailing)
//                            case .response(let response):
//                                MessageView(segments: response.segments, isUser: false)
//                                    .padding(.leading, 10)
//                            default:
//                                EmptyView()
//                            }
//                        }
//                    }
//                }
//                .animation(.easeInOut, value: model.session.transcript)
//                
//                if model.isAwaitingResponse {
//                    if let last = model.session.transcript.last {
//                        if case .prompt = last {
//                            Text("Thinking...").bold()
//                                .opacity(model.isThinking ? 0.5 : 1)
//                                .padding(.leading)
//                                .offset(y: 15)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .onAppear {
//                                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
//                                        model.isThinking.toggle()
//                                    }
//                                }
//                        }
//                    }
//                }
//            }
//            .defaultScrollAnchor(.bottom, for: .sizeChanges)
//            .safeAreaPadding(.bottom, 100)
//            
//            HStack {
//                TextField("ask me antyhing...", text: $model.inputText, axis: .vertical)
//                    .textFieldStyle(.plain)
//                    .disabled(model.session.isResponding)
//                    .frame(height: 55)
//                
//                Button {
//                    model.sendMessage()
//                } label: {
//                    Image(systemName: "arrow.up.circle.fill")
//                        .font(.system(size: 30, weight: .bold))
//                        .foregroundStyle(model.session.isResponding ? Color.gray.opacity(0.6) : .primary)
//                }
//                .disabled(model.inputText.isEmpty || model.session.isResponding)
//            }
//            .padding(.horizontal)
//            .glassEffect(.regular.interactive())
//            .padding()
//            .frame(maxHeight: .infinity, alignment: .bottom)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//import FoundationModels
//
//
//@Observable
//class LMModel {
//    var inputText = "hi"
//    var isThinking = false
//    var isAwaitingResponse = false
//    var session = LanguageModelSession {
//        """
//        "You are a helpful and concise assistant. Provide clear, accurate answers in a professional".
//        """
//    }
//    
//    func sendMessage() {
//        Task {
//            do {
//                let prompt = Prompt(inputText)
//                inputText = ""
//                let strame = session.streamResponse(to: prompt)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.isAwaitingResponse = true
//                }
//                
//                for try await prontresponse in strame {
//                    isAwaitingResponse = false
//                    print(prontresponse)
//                }
//                
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//struct MessageView: View {
//    let segments: [Transcript.Segment]
//    let isUser: Bool
//    var body: some View {
//        VStack {
//            ForEach(segments, id: \.id) { segment in
//                switch segment {
//                case .text(let text):
//                    Text(text.content).padding(10)
//                        .background(isUser ? Color.gray.opacity(0.2) : .clear, in: .rect(cornerRadius: 12))
//                        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
//                case .structure:
//                    EmptyView()
//                @unknown default:
//                    EmptyView()
//                }
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//}


// ComposeView.swift
import SwiftUI

@available(iOS 26.0, *)
struct ContentView: View {
    @State private var text = ""
    @State private var isLoading = false
    @FocusState private var focused: Bool
    private let assistant = Assistant()

    var body: some View {
        VStack(spacing: 12) {
            TextEditor(text: $text)
                .focused($focused)
                .padding()
                .frame(minHeight: 200)

            if Assistant.isAvailable {
                Menu {
                    Button("Correct")   { run(.correct) }
                    Button("Emphasize") { run(.emphasize) }
                    Button("Hashtags")  { runTags() }
                } label: {
                    Image(systemName: "wand.and.stars")
                }
                .disabled(isLoading)
            } else {
                Text("Apple Intelligence unavailable on this device")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .task { assistant.prewarm() }   // preload model
    }

    private enum Action { case correct, emphasize }

    private func run(_ action: Action) {
        isLoading = true
        let original = text                                // undo support
        Task {
            let stream: LanguageModelSession.ResponseStream<String>? = switch action {
            case .correct:   await assistant.correct(text)
            case .emphasize: await assistant.emphasize(text)
            }
            do {
                if let stream {
                    for try await chunk in stream {
                        await MainActor.run { text = chunk }
                    }
                }
            } catch { text = original }
            isLoading = false
        }
    }

    private func runTags() {
        isLoading = true
        Task {
            let tags = await assistant.hashtags(for: text)
            if !tags.isEmpty { text += "\n" + tags.joined(separator: " ") }
            isLoading = false
        }
    }
}

// Assistant.swift
// Requires: import FoundationModels, available iOS 26+

import FoundationModels
import SwiftUI

@Generable
struct Tags {
    @Guide(description: "Camel‑cased, prefixed with #", .count(5))
    let values: [String]        // e.g. ["#SwiftLang", "#IceCubes"]
}

@available(iOS 26.0, *)
struct Assistant {
    // Check dynamically – user can disable Apple Intelligence at any time
    static var isAvailable: Bool { SystemLanguageModel.default.isAvailable }

    private let session: LanguageModelSession = .init(model: .init(useCase: .general)) {
        """
        You help users compose Mastodon posts (≤500 chars).
        """
    }

    // Call once (e.g. when the compose screen appears) to avoid first‑hit latency
    func prewarm() { session.prewarm() }

    // MARK: — Tasks ----------------------------------------------------------

    func correct(_ text: String) async -> LanguageModelSession.ResponseStream<String>? {
        session.streamResponse(
            to: "Fix the spelling and grammar mistakes in: \(text)",
            options: .init(temperature: 0.3)
        )
    }

    func emphasize(_ text: String) async -> LanguageModelSession.ResponseStream<String>? {
        session.streamResponse(
            to: "Make this text catchy, more fun: \(text)",
            options: .init(temperature: 2.0)
        )
    }

    func hashtags(for text: String) async -> [String] {
        do {
            // Schema included once; omit on later turns with includeSchemaInPrompt: false
            let result = try await session.respond(
                to: "Generate hashtags for: \(text)",
                generating: Tags.self
            )
            return result.content.values
        } catch { return [] }
    }
}
