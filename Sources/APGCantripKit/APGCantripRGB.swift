//  APGCantripRGB.swift
//  APGCantripKit
//
//  Created by Steve Sheets on 8/25/25.
//
//  Cross-platform bridges (SwiftUI.Color / NSColor / UIColor), presets, hex parsing,
//  and package-wide globals for app/link colors.
//

// MARK: - Imports

#if canImport(AppKit)

import AppKit

#endif

#if canImport(UIKit)

import UIKit

#endif

#if canImport(SwiftUI)

import SwiftUI

#endif

// MARK: - Typealias

#if canImport(AppKit)

public typealias APGCantripImage = NSImage

#elseif canImport(UIKit)

public typealias APGCantripImage = UIImage

#endif

// MARK: - Constants & Globals

/// Default clickable link color used by APGCantrip helpers.
/// Chooses the platform-native link color when available, falling back to `.linkDefault` blue.
public let gCantripLinkRGB: APGCantripRGB = {
    
#if canImport(AppKit)
    
    return APGCantripRGB(nsColor: .linkColor)
    
#elseif canImport(UIKit)
    
    return APGCantripRGB(uiColor: .link)
    
#else
    
    return .linkDefault
    
#endif
    
}()

/// Optional app-accent color to be shared across packages (`nil` by default).
/// This can be set by the host app to override styling globally.
/// - Important: Access this from background threads via `await MainActor.run { gCantripAppRGB }`.
@MainActor public var gCantripAppRGB: APGCantripRGB? = nil

// MARK: - Struct

/// A simple RGB color container using integer channels (0–255).
/// Includes alpha channel for opacity.
public struct APGCantripRGB: Equatable, Hashable, Codable, Sendable {
    public var red: Int      /// Red channel (0–255)
    public var green: Int    /// Green channel (0–255)
    public var blue: Int     /// Blue channel (0–255)
    public var alpha: Int    /// Alpha channel (0–255)

    // MARK: - Init

    /// Create a new RGB color with clamping to the 0–255 range.
    /// - Parameters:
    ///   - red: Red channel (0–255)
    ///   - green: Green channel (0–255)
    ///   - blue: Blue channel (0–255)
    ///   - alpha: Alpha channel (0–255, default 255 = opaque)
    public init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.red   = red.cantripClamped(to: 0...255)
        self.green = green.cantripClamped(to: 0...255)
        self.blue  = blue.cantripClamped(to: 0...255)
        self.alpha = alpha.cantripClamped(to: 0...255)
    }
}

// MARK: - Extensions

public extension Int {
    /// Clamp an integer to a closed range, under the `cantrip` namespace.
    /// - Parameter range: The range to clamp into.
    /// - Returns: The clamped integer.
    func cantripClamped(to range: ClosedRange<Int>) -> Int {
        return Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Platform Bridges

public extension APGCantripRGB {
    
#if canImport(SwiftUI)
    
    /// Bridge to `SwiftUI.Color` in the sRGB color space.
    var swiftUIColor: Color {
        Color(.sRGB,
              red: Double(red) / 255.0,
              green: Double(green) / 255.0,
              blue: Double(blue) / 255.0,
              opacity: Double(alpha) / 255.0)
    }
    
#endif
    
#if canImport(AppKit)
    
    /// Bridge to `NSColor` in the sRGB color space.
    var nsColor: NSColor {
        NSColor(srgbRed: CGFloat(Double(red) / 255.0),
                green: CGFloat(Double(green) / 255.0),
                blue: CGFloat(Double(blue) / 255.0),
                alpha: CGFloat(Double(alpha) / 255.0))
    }
    
    /// Initialize from an `NSColor` (converted to sRGB), clamped to 0–255.
    init(nsColor: NSColor) {
        let c = nsColor.usingColorSpace(.sRGB) ?? nsColor
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        c.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: Int((r * 255).rounded()),
                  green: Int((g * 255).rounded()),
                  blue: Int((b * 255).rounded()),
                  alpha: Int((a * 255).rounded()))
    }
#endif
    
#if canImport(UIKit)
    
    /// Bridge to `UIColor` in the sRGB color space.
    var uiColor: UIColor {
        UIColor(red: CGFloat(Double(red) / 255.0),
                green: CGFloat(Double(green) / 255.0),
                blue: CGFloat(Double(blue) / 255.0),
                alpha: CGFloat(Double(alpha) / 255.0))
    }
    
    /// Initialize from a `UIColor` (converted to sRGB), clamped to 0–255.
    init(uiColor: UIColor) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: Int((r * 255).rounded()),
                  green: Int((g * 255).rounded()),
                  blue: Int((b * 255).rounded()),
                  alpha: Int((a * 255).rounded()))
    }
    
#endif
    
}

// MARK: - Presets

public extension APGCantripRGB {
    
    // --- Basic named colors ---
    
    /// Pure black
    static let black = APGCantripRGB(red: 0, green: 0, blue: 0)
    
    /// Pure white
    static let white = APGCantripRGB(red: 255, green: 255, blue: 255)
    
    /// System-like red
    static let red = APGCantripRGB(red: 255, green: 59, blue: 48)
    
    /// System-like green
    static let green = APGCantripRGB(red: 52, green: 199, blue: 89)
    
    /// System-like link blue
    static let blue = APGCantripRGB(red: 0, green: 122, blue: 255)
    
    /// Orange
    static let orange = APGCantripRGB(red: 255, green: 149, blue: 0)
    
    /// Yellow
    static let yellow = APGCantripRGB(red: 255, green: 204, blue: 0)
    
    /// Purple
    static let purple = APGCantripRGB(red: 175, green: 82, blue: 222)
    
    /// Pink
    static let pink = APGCantripRGB(red: 255, green: 45, blue: 85)
    
    /// Teal
    static let teal = APGCantripRGB(red: 90, green: 200, blue: 250)
    
    /// Indigo
    static let indigo = APGCantripRGB(red: 88, green: 86, blue: 214)
    
    /// Brown
    static let brown = APGCantripRGB(red: 162, green: 132, blue: 94)
    
    
    // --- CMY & web classics ---
    
    /// Cyan
    static let cyan = APGCantripRGB(red: 50, green: 173, blue: 230)
    
    /// Magenta
    static let magenta = APGCantripRGB(red: 255, green: 0, blue: 255)
    
    /// Maroon
    static let maroon = APGCantripRGB(red: 128, green: 0, blue: 0)
    
    /// Olive
    static let olive = APGCantripRGB(red: 128, green: 128, blue: 0)
    
    /// Navy
    static let navy = APGCantripRGB(red: 0, green: 0, blue: 128)
    
    /// Lime green
    static let lime = APGCantripRGB(red: 0, green: 255, blue: 0)
    
    /// Aqua
    static let aqua = APGCantripRGB(red: 0, green: 255, blue: 255)
    
    /// Fuchsia
    static let fuchsia = APGCantripRGB(red: 255, green: 0, blue: 255)
    
    /// Silver
    static let silver = APGCantripRGB(red: 192, green: 192, blue: 192)
    
    
    // --- Grays (US spelling) ---
    
    /// Neutral gray
    static let gray = APGCantripRGB(red: 142, green: 142, blue: 147)
    
    /// Light gray
    static let lightGray = APGCantripRGB(red: 199, green: 199, blue: 204)
    
    /// Dark gray
    static let darkGray = APGCantripRGB(red: 72, green: 72, blue: 74)
    
    
    // --- Greys (UK spelling aliases) ---
    
    /// Alias for gray
    static let grey = gray
    
    /// Alias for lightGray
    static let lightGrey = lightGray
    
    /// Alias for darkGray
    static let darkGrey = darkGray
    
    
    // --- Links ---
    
    /// Default link blue
    static let linkDefault = blue
}

// MARK: - Hex parsing & utilities

public extension APGCantripRGB {
    /// Initialize from a hex string (`#RGB`, `#RRGGBB`, or `#RRGGBBAA`).
    /// Alpha is optional; defaults to 255 (opaque).
    init?(hex: String) {
        let s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: APGCantrip.hash, with: String())
                    .lowercased()

        func hex2(_ i: Int) -> Int {
            let start = s.index(s.startIndex, offsetBy: i)
            let end = s.index(start, offsetBy: 2)
            return Int(s[start..<end], radix: 16) ?? 0
        }

        switch s.count {
        case 3: // #RGB → expand 4-bit values to 8-bit
            let r = Int(String(s[s.startIndex]), radix: 16) ?? 0
            let g = Int(String(s[s.index(s.startIndex, offsetBy: 1)]), radix: 16) ?? 0
            let b = Int(String(s[s.index(s.startIndex, offsetBy: 2)]), radix: 16) ?? 0
            self.init(red: r * 17, green: g * 17, blue: b * 17)
        case 6: // #RRGGBB
            self.init(red: hex2(0), green: hex2(2), blue: hex2(4))
        case 8: // #RRGGBBAA
            self.init(red: hex2(0), green: hex2(2), blue: hex2(4), alpha: hex2(6))
        default:
            return nil
        }
    }

    /// Return a copy of the color with a modified alpha.
    /// - Parameter a: New alpha channel (0–255).
    func withAlpha(_ a: Int) -> APGCantripRGB {
        APGCantripRGB(red: red, green: green, blue: blue, alpha: a)
    }
}
