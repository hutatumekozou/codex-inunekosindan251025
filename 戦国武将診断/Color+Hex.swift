import SwiftUI

extension Color {
    init?(hex: String) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6 || s.count == 8 else { return nil }
        var v: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&v) else { return nil }
        let a, r, g, b: Double
        if s.count == 8 {
            a = Double((v & 0xFF000000) >> 24) / 255.0
            r = Double((v & 0x00FF0000) >> 16) / 255.0
            g = Double((v & 0x0000FF00) >> 8) / 255.0
            b = Double(v & 0x000000FF) / 255.0
        } else {
            a = 1.0
            r = Double((v & 0xFF0000) >> 16) / 255.0
            g = Double((v & 0x00FF00) >> 8) / 255.0
            b = Double(v & 0x0000FF) / 255.0
        }
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
