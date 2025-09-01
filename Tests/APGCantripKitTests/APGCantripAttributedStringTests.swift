//
//  APGCantripAttributedStringTests.swift
//  APGCantripKit
//
//  Created by Steve Sheets on 8/31/25.
//
//  Unit tests for APGCantrip+AttributedString.swift

import XCTest
import SwiftUI
@testable import APGCantripKit

final class APGCantripAttributedStringTests: XCTestCase {

    let sampleText = "Hello, world!"
    let sampleURL = "https://example.com"

    @MainActor func testParagraphStyles() {
        var attr = AttributedString()
        attr.cantripP(sampleText)
        attr.cantripH1(sampleText)
        attr.cantripH2(sampleText)
        attr.cantripH3(sampleText)
        attr.cantripH4(sampleText)
        attr.cantripH5(sampleText)

        XCTAssertFalse(attr.characters.isEmpty)
    }

    @MainActor func testStaticParagraphStyles() {
        let _ = AttributedString.cantripP(sampleText)
        let _ = AttributedString.cantripH1(sampleText)
        let _ = AttributedString.cantripH2(sampleText)
        let _ = AttributedString.cantripH3(sampleText)
        let _ = AttributedString.cantripH4(sampleText)
        let _ = AttributedString.cantripH5(sampleText)
    }

    @MainActor func testInlineText() {
        var attr = AttributedString()
        attr.cantripText(sampleText)
        XCTAssertFalse(attr.characters.isEmpty)

        let staticText = AttributedString.cantripText(sampleText)
        XCTAssertFalse(staticText.characters.isEmpty)
    }

    @MainActor func testLink() {
        var attr = AttributedString()
        attr.cantripLink(sampleText, sampleURL)
        XCTAssertFalse(attr.characters.isEmpty)

        attr = AttributedString()
        attr.cantripBannerLink(sampleText, sampleURL)
        XCTAssertFalse(attr.characters.isEmpty)

        let link = AttributedString.cantripLink(sampleText, sampleURL)
        XCTAssertFalse(link.characters.isEmpty)
        XCTAssertEqual(link.link, URL(string: sampleURL))

        let link2 = AttributedString.cantripBannerLink(sampleText, sampleURL)
        XCTAssertFalse(link2.characters.isEmpty)
        XCTAssertEqual(link2.link, URL(string: sampleURL))
    }

    @MainActor func testBannerLink() {
        var attr = AttributedString()
        attr.cantripBannerLink(sampleText, sampleURL)
        XCTAssertFalse(attr.characters.isEmpty)

        let banner = AttributedString.cantripBannerLink(sampleText, sampleURL)
        XCTAssertFalse(banner.characters.isEmpty)
    }

    @MainActor func testLineGeneration() {
        var attr = AttributedString()
        attr.cantripLine(width: 100)
        XCTAssertFalse(attr.characters.isEmpty)

        let staticLine = AttributedString.cantripLine(width: 100)
        XCTAssertFalse(staticLine.characters.isEmpty)
    }

//    @MainActor func testImageInline() {
//        guard let testImage = APGCantrip.cantripLoadImage(named: "TestImage") else {
//            return XCTFail("Image not found in assets")
//        }
//
//        var attr = AttributedString()
//        attr.cantripImage(testImage)
//        XCTAssertFalse(attr.characters.isEmpty)
//
//        let staticImage = AttributedString.cantripImage(testImage)
//        XCTAssertFalse(staticImage.characters.isEmpty)
//    }

//    @MainActor func testImageNamed() {
//        var attr = AttributedString()
//        let result = attr.cantripImage(named: "TestImage")
//        XCTAssertTrue(result)
//        XCTAssertFalse(attr.characters.isEmpty)
//    }

    @MainActor func testParagraphEnd() {
        var attr = AttributedString()
        attr.cantripParagraphEnd()
        XCTAssertFalse(attr.characters.isEmpty)

        let staticEnd = AttributedString.cantripParagraphEnd()
        XCTAssertFalse(staticEnd.characters.isEmpty)
    }
}
