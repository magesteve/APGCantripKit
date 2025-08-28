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
    
    /// Append a normal paragraph (P) of text using the CSS `text` font.
    mutating func cantripP(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).text, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Append a level-1 header using the CSS `h1` font.
    mutating func cantripH1(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h1, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Append a level-2 header using the CSS `h2` font.
    mutating func cantripH2(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h2, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Append a level-3 header using the CSS `h3` font.
    mutating func cantripH3(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h3, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Append a level-4 header using the CSS `h4` font.
    mutating func cantripH4(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h4, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Append a level-5 header using the CSS `h5` font.
    mutating func cantripH5(_ text: String, css: APGCantripCSS? = nil) {
        self += Self._cantripMakeBlock(text, font: (css ?? .standard).h5, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    // MARK: - Static Functions (paragraphs)
    
    /// Build a paragraph of normal text with the CSS `text` font.
    static func cantripP(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).text, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Build a paragraph with the CSS `h1` font.
    static func cantripH1(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h1, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Build a paragraph with the CSS `h2` font.
    static func cantripH2(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h2, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Build a paragraph with the CSS `h3` font.
    static func cantripH3(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h3, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Build a paragraph with the CSS `h4` font.
    static func cantripH4(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h4, verticalSpace: (css ?? .standard).verticalSpace)
    }
    
    /// Build a paragraph with the CSS `h5` font.
    static func cantripH5(_ text: String, css: APGCantripCSS? = nil) -> AttributedString {
        _cantripMakeBlock(text, font: (css ?? .standard).h5, verticalSpace: (css ?? .standard).verticalSpace)
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
    static func _cantripMakeBlock(_ text: String, font: APGCantripFont, verticalSpace: Bool) -> AttributedString {
        var s = _cantripMakeInline(text, font: font)
        if s.characters.last != APGCantrip.lineFeedChar {
            s.append(AttributedString(APGCantrip.lineFeed))
        }
        if verticalSpace {
            s.append(AttributedString(APGCantrip.lineFeed))
        }
        return s
    }
    
    // MARK: - Horizontal Line

    /// Build a horizontal line as an inline run.
    /// - Parameters:
    ///   - width: Total width of the line in points (usually the view width).
    ///   - thickness: Line thickness (default 1 point).
    ///   - color: Optional line color. Defaults to system gray.
    static func cantripLine(width: CGFloat,
                            thickness: CGFloat = 1.0,
                            color: APGCantripRGB? = nil) -> AttributedString {
        let attachment = NSTextAttachment()

#if canImport(AppKit)
        let lineSize = CGSize(width: width, height: thickness)
        let lineImage = NSImage(size: lineSize, flipped: false) { rect in
            (color?.nsColor ?? .separatorColor).setFill()
            rect.fill()
            return true
        }
        attachment.image = lineImage
        attachment.bounds = CGRect(origin: .zero, size: lineSize)
        #elseif canImport(UIKit)
        let lineSize = CGSize(width: width, height: thickness)
        UIGraphicsBeginImageContextWithOptions(lineSize, false, 0)
        (color?.uiColor ?? .separator).setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: lineSize)).fill()
        let lineImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        attachment.image = lineImage
        attachment.bounds = CGRect(origin: .zero, size: lineSize)
#endif

        return AttributedString(NSAttributedString(attachment: attachment))
    }

    /// Append a horizontal line to this attributed string.
    mutating func cantripLine(width: CGFloat,
                              thickness: CGFloat = 1.0,
                              color: APGCantripRGB? = nil) {
        self += Self.cantripLine(width: width, thickness: thickness, color: color)
        self.cantripParagraphEnd() // move to new line after the rule
    }
    
    // MARK: - Image (APGCantripImage) — static builder

    /// Build an inline image run from an `APGCantripImage`.
    /// - Parameters:
    ///   - image: Platform image (`NSImage` on macOS, `UIImage` on iOS).
    ///   - size: Optional display size (points). If nil, uses the image's intrinsic size.
    ///   - baselineOffset: Optional vertical tweak (points) relative to baseline. Positive moves up.
    /// - Returns: An `AttributedString` containing the image as a single inline run.
    static func cantripImage(_ image: APGCantripImage,
                             size: CGSize? = nil,
                             baselineOffset: CGFloat = 0) -> AttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image

        if let size {
            attachment.bounds = CGRect(origin: .zero, size: size)
        } else {
#if canImport(AppKit)
            if let rep = image.bestRepresentation(for: .zero, context: nil, hints: nil) {
                attachment.bounds = CGRect(origin: .zero,
                                           size: CGSize(width: rep.pixelsWide, height: rep.pixelsHigh))
            }
#elseif canImport(UIKit)
            attachment.bounds = CGRect(origin: .zero, size: image.size)
#endif
        }

        let ns = NSMutableAttributedString(attachment: attachment)

        if baselineOffset != 0 {
            ns.addAttribute(.baselineOffset,
                            value: baselineOffset,
                            range: NSRange(location: 0, length: ns.length))
        }

        return AttributedString(ns)
    }

    // MARK: - Image (APGCantripImage) — mutating appender

    /// Append an `APGCantripImage` as an inline run to this attributed string.
    mutating func cantripImage(_ image: APGCantripImage,
                               size: CGSize? = nil,
                               baselineOffset: CGFloat = 0) {
        self += Self.cantripImage(image, size: size, baselineOffset: baselineOffset)
    }

    /// Append an asset image (by name) as an inline run.
    /// Returns `true` if the image was found and appended; `false` otherwise.
    @discardableResult
    mutating func cantripImage(named name: String,
                               size: CGSize? = nil,
                               baselineOffset: CGFloat = 0) -> Bool {
        guard let image = APGCantrip.cantripLoadImage(named: name) else { return false }
        self += Self.cantripImage(image, size: size, baselineOffset: baselineOffset)
        return true
    }
    
}

public extension AttributedString {
    
    // MARK: - Paragraph end (line feed) — data-only

    /// Append a newline to end the current paragraph.
    mutating func cantripParagraphEnd() {
        self.append(AttributedString(APGCantrip.lineFeed))
    }
    
    /// Build a single newline as an attributed string.
    static func cantripParagraphEnd() -> AttributedString {
        AttributedString(APGCantrip.lineFeed)
    }
}
