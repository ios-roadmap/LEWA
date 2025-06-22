//
//  ImageLoaderView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 22.06.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    let urlString: String
    var forceTransitionAnimation: Bool = false
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: .init(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: .fill)
                    .allowsHitTesting(false)
            }
            .clipped()
            .ifStatisfiedCondition(forceTransitionAnimation, transform: { content in
                content
                    .drawingGroup()
            })
    }
}
