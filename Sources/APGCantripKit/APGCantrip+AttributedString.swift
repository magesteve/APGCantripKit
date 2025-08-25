//  APGCantrip+AttributedString.swift
//  APGCantripKit
//
//  AppKit/UIKit–centric AttributedString utilities with a CSS-like source (APGCantripCSS).
//  Every API is prefixed with `cantrip` and accepts an optional `css:`.
//  Link helpers respect gCantripLinkRGB for coloring.

// MARK: - Imports

import Foundation

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Extensions

@MainActor
public extension AttributedString {

    // MARK: - Mutating Functions (paragraphs)

    /// Append a normal paragraph (P1) of text using the CSS `text` font.
    mutating func cantripP1(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).text)
    }

    /// Append a level-1 header using the CSS `h1` font.
    mutating func cantripH1(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h1)
    }

    /// Append a level-2 header using the CSS `h2` font.
    mutating func cantripH2(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h2)
    }

    /// Append a level-3 header using the CSS `h3` font.
    mutating func cantripH3(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h3)
    }

    /// Append a level-4 header using the CSS `h4` font.
    mutating func cantripH4(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h4)
    }

    /// Append a level-5 header using the CSS `h5` font.
    mutating func cantripH5(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h5)
    }

    // MARK: - Static Functions (paragraphs)

    /// Build a paragraph of normal text with the CSS `text` font.
    static func cantripP1(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).text)
    }

    /// Build a paragraph with the CSS `h1` font.
    static func cantripH1(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h1)
    }

    /// Build a paragraph with the CSS `h2` font.
    static func cantripH2(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h2)
    }

    /// Build a paragraph with the CSS `h3` font.
    static func cantripH3(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h3)
    }

    /// Build a paragraph with the CSS `h4` font.
    static func cantripH4(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h4)
    }

    /// Build a paragraph with the CSS `h5` font.
    static func cantripH5(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h5)
    }

    // MARK: - Utility Functions

    /// Append inline text using the CSS `text` font (no paragraph break).
    mutating func cantripText(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeInline(text, font: (css ?? .standard).text)
    }

    /// Build inline text using the CSS `text` font (no paragraph break).
    static func cantripText(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeInline(text, font: (css ?? .standard).text)
    }

    // MARK: - Link (clickable text)

    /// Append a clickable text run with normal `text` font and a link color.
    mutating func cantripLink(_ text: String, _ ref: String, css: APGCantripCSS? = nil, linkRGB: APGCantripRGB? = nil) {
        self += Self.cantripLink(text, ref, css: css, linkRGB: linkRGB)
    }

    /// Build a clickable text run with normal `text` font and a link color.
    /// Adds underline style and attaches `.link` attribute if `ref` parses as a URL.
    static func cantripLink(_ text: String, _ ref: String, css: APGCantripCSS? = nil, linkRGB: APGCantripRGB? = nil) -> AttributedString {
        var s = _cantripMakeInline(text, font: (css ?? .standard).text)

        let aRGB = linkRGB ?? gCantripLinkRGB

        #if canImport(AppKit)
        s.appKit.foregroundColor = aRGB.nsColor
        #elseif canImport(UIKit)
        s.uiKit.foregroundColor = aRGB.uiColor
        #endif

        s.underlineStyle = .single

        if let url = URL(string: ref) {
            s.link = url
        }
        return s
    }

    // MARK: - Internal factories

    /// Internal: create an inline attributed run with a specific font.
    /// Uses NSAttributedString bridging to safely attach NSFont/UIFont.
    static func _cantripMakeInline(_ text: String, font: APGCantripFont) -> AttributedString {
        #if canImport(AppKit)
        let ns = NSMutableAttributedString(
            string: text,
            attributes: [.font: font]  // apply NSFont
        )
        return AttributedString(ns)
        #elseif canImport(UIKit)
        let ns = NSMutableAttributedString(
            string: text,
            attributes: [.font: font]  // apply UIFont
        )
        return AttributedString(ns)
        #else
        return AttributedString(text)
        #endif
    }
    
    /// Internal: create a block of attributed text (with font) that ends in a newline.
    static func _cantripMakeBlock(_ text: String, font: APGCantripFont) -> AttributedString {
        var s = _cantripMakeInline(text, font: font)
        if s.characters.last != "\n" {
            s.append(AttributedString("\n"))
        }
        return s
    }
}

public extension AttributedString {
    
    // MARK: - Paragraph end (line feed) — data-only

    /// Append a newline to end the current paragraph.
    mutating func cantripParagraphEnd() {
        self.append(AttributedString("\n"))
    }
    
    /// Build a single newline as an attributed string.
    static func cantripParagraphEnd() -> AttributedString {
        AttributedString("\n")
    }
}
