//
//  Color+Ext.swift
//  LEWA
//
//  Created by Ömer Faruk Öztürk on 24.06.2025.
//

import SwiftUI

#if os(iOS)
import UIKit          // UIColor
#elseif os(macOS)
import AppKit         // NSColor
#endif

public extension Color {

    // MARK: – Init from hex
    init(hex: String) {
        let clean = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch clean.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17,
                                       (int >> 4 & 0xF) * 17,
                                       (int       & 0xF) * 17)
        case 6:  (a, r, g, b) = (255,  int >> 16,
                                       int >> 8  & 0xFF,
                                       int        & 0xFF)
        case 8:  (a, r, g, b) = ( int >> 24,
                                  int >> 16 & 0xFF,
                                  int >> 8  & 0xFF,
                                  int        & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self = Color(.sRGB,
                     red:   Double(r) / 255,
                     green: Double(g) / 255,
                     blue:  Double(b) / 255,
                     opacity: Double(a) / 255)
    }

    // MARK: – Convert to hex
    func asHex(includeAlpha: Bool = false) -> String {

        // ---------- platform-specific bridge ----------
        #if os(iOS)
        let native = UIColor(self)
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        guard native.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return includeAlpha ? "#00000000" : "#000000"
        }
        #elseif os(macOS)
        let nsColor = NSColor(self).usingColorSpace(.sRGB) ?? .black
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        // ---------------------------------------------

        let red   = Int(r * 255)
        let green = Int(g * 255)
        let blue  = Int(b * 255)
        let alpha = Int(a * 255)

        return includeAlpha
            ? String(format: "#%02X%02X%02X%02X", alpha, red, green, blue)
            : String(format: "#%02X%02X%02X",       red, green, blue)
    }
}
