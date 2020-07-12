//
//  ColorExtension.swift
//  Trickl
//
// https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui

import Foundation
import SwiftUI
extension Color {
    
    /// extract Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// serialize Color as Hex String
    /// https://cocoacasts.com/how-to-store-uicolor-in-core-data-persistent-store
    var toHex: String? {
        // Extract Components
        let (r,g,b,a) = self.components()

        // Create Hex String
        let hex = String(
            format: "%02lX%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255)),
            lroundf(Float(a * 255))
        )

        return hex
    }
}

/// https://stackoverflow.com/questions/57257704/how-can-i-change-a-swiftui-color-to-uicolor
extension Color {

    func uiColor() -> UIColor {
        let components = self.components()
        return UIColor(
            red: components.r,
            green: components.g,
            blue: components.b,
            alpha: components.a
        )
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}


/// my custom colors
extension Color {

    // middle of the road grey, replace with dark mode sensitive color later
    static let noProject = Color(
        red: 0.5,
        green: 0.5,
        blue: 0.5
    )
    
    static let clokBG = Color("ClokBG")
}
