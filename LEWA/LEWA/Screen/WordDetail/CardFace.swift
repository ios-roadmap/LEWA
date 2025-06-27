//
//  CardFace.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

struct CardFace: View {
    let text: String
    let color: Color

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 14)
                .fill(.thinMaterial)
            
            VStack {
                Text(text)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .foregroundStyle(color)
                    .padding(.horizontal, 12)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
