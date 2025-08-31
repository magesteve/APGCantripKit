//
//  APGCantripCSS.swift
//  APGCantripKit
//
//  Created by Steve Sheets on 8/25/25.
//
//  Simple CSS-like font style holder for Cantrip.
//  Provides a global default stylesheet, main-actor isolated for safety.

// MARK: - Import

import Foundation

#if canImport(AppKit)

import AppKit

#elseif canImport(UIKit)

import UIKit

#endif


// MARK: - typealias

#if canImport(AppKit)

public typealias APGCantripFont = NSFont
public typealias APGCantripColor = NSColor

#elseif canImport(UIKit)

public typealias APGCantripFont = UIFont
public typealias APGCantripColor = UIColor

#endif


/// A simple CSS-like font style container for APGCantrip.
/// Holds font information for body text and heading levels.
public final class APGCantripCSS: @unchecked Sendable, ObservableObject {
    
    public static let standard: APGCantripCSS = APGCantripCSS()
    
    public var text: APGCantripFont
    public var bold: APGCantripFont
    public var h1: APGCantripFont
    public var h2: APGCantripFont
    public var h3: APGCantripFont
    public var h4: APGCantripFont
    public var h5: APGCantripFont
    
    public var verticalSpace: Bool
    
    // MARK: - Init
    
    public init(text: APGCantripFont = APGCantripFont.systemFont(ofSize: 12),
                bold: APGCantripFont = APGCantripFont.boldSystemFont(ofSize: 12),
                h1: APGCantripFont = APGCantripFont.boldSystemFont(ofSize: 28),
                h2: APGCantripFont = APGCantripFont.boldSystemFont(ofSize: 24),
                h3: APGCantripFont = APGCantripFont.boldSystemFont(ofSize: 20),
                h4: APGCantripFont = APGCantripFont.boldSystemFont(ofSize: 18),
                h5: APGCantripFont = APGCantripFont.systemFont(ofSize: 16),
                verticalSpace: Bool = true) {
        self.text = text
        self.bold = bold
        self.h1 = h1
        self.h2 = h2
        self.h3 = h3
        self.h4 = h4
        self.h5 = h5
        self.verticalSpace = verticalSpace
    }

}
