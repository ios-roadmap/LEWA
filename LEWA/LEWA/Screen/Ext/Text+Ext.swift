//
//  Text+Ext.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 27.06.2025.
//

import SwiftUI

extension Text {
    static func commaSeparated(_ items: [String]) -> Text {
        guard let first = items.first else { return Text("") }
        return items.dropFirst().reduce(Text(first)) { result, next in
            result + Text(", ") + Text(next)
        }
    }
}
