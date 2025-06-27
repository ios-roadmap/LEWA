//
//  StarredWord.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import Foundation
import SwiftData

@Model                               // ← required for SwiftData
class StarredWord: Identifiable {
    var id: String                 // root spelling you show in the UI
    var isStarred: Bool       // you can drop this if “existence = starred”

    init(id: String, isStarred: Bool) {
        self.id = id
        self.isStarred = isStarred
    }
}
