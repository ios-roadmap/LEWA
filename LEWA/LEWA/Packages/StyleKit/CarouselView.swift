//
//  CarouselView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct CarouselView<Content: View, T: Hashable>: View {
    
    var items: [T]
    @State private var selection: T? = nil
    @ViewBuilder var content: (T) -> Content
    
    var body: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                            .scrollTransition(
                                .interactive.threshold(.visible(0.6)),
                                axis: .horizontal,
                                transition: { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                }
                            )
                            .containerRelativeFrame(.horizontal, alignment: .center)
                            .id(item)
                            .onChange(of: items.count, { oldValue, newValue in
                                updateSelectionIfNeeded()
                            })
                            .onAppear {
                                updateSelectionIfNeeded()
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $selection)
            
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Circle()
                        .fill(item == selection ? .red : .gray)
                        .frame(width: 8, height: 8)
                }
            }
            .animation(.linear, value: selection)
        }
    }
    
    private func updateSelectionIfNeeded() {
        if selection == nil || selection == items.last {
            selection = items.first
        }
    }
}
