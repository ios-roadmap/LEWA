//
//  TabBarView.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        NavigationStack {
            TabView {
                DictionarySearchView()
                    .tabItem {
                        Label("Explore", systemImage: "text.page.badge.magnifyingglass")
                    }
                
                Text("Stars")
                    .tabItem {
                        Label("Star", systemImage: "star.fill")
                    }
                
                Text("Flashcards")
                    .tabItem {
                        Label("Flashcards", systemImage: "rectangle.portrait.on.rectangle.portrait.angled")
                    }
            }
        }
    }
}

#Preview {
    TabBarView()
}
