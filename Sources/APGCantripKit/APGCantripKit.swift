//
//  APGCantrip.swift
//  APGCantripKit
//
//  Created by Steve Sheets on 8/24/25.
//

import Foundation
import AVFoundation
import UserNotifications

#if canImport(SystemConfiguration)

import SystemConfiguration

#endif

#if canImport(AppKit)

import AppKit
import IOKit.pwr_mgt          

#endif

#if canImport(UIKit)

import UIKit

#endif

/// Abstract Namespace for Package Information & Reusable Cantrips
public class APGCantrip {

    // MARK: - Package Info

    /// Version information of package
    public static let version = "0.5.2"
    
    // MARK: Constants
    
    /// Line Feed
    public static let lineFeed = "\n"

    /// Has
    public static let hash = "#"

    /// Line Feed Char
    public static let lineFeedChar: Character = "\n"

    // MARK: - Cross-Platform (or mostly)

    /// Return application name from Info.plist.
    public static func appName() -> String {
        let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        let bundleName  = Bundle.main.infoDictionary?["CFBundleName"] as? String
        return displayName ?? bundleName ?? "UnknownApp"
    }

    /// Return application version string, e.g. "v1.2 (45)".
    public static func appVersionString() -> String {
        let versionKey = "CFBundleShortVersionString"
        let buildKey = kCFBundleVersionKey as String

        let version = (Bundle.main.object(forInfoDictionaryKey: versionKey) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let build = (Bundle.main.object(forInfoDictionaryKey: buildKey) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let safeVersion = (version?.isEmpty == false) ? version! : "1.0"
        let safeBuild   = (build?.isEmpty == false) ? build!   : ""

        return "v\(safeVersion)" + (safeBuild.isEmpty ? "" : " (\(safeBuild))")
    }

    /// Return copyright string from Info.plist (NSHumanReadableCopyright), or empty.
    public static func copyrightString() -> String {
        Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String ?? ""
    }

    /// Convenience “About” string.
    public static func aboutString() -> String {
        "\(appName()) \(appVersionString()) — \(copyrightString())"
    }

    /// App bundle identifier or fallback.
    public static func appBundleID() -> String {
        Bundle.main.bundleIdentifier ?? "UnknownBundle"
    }

    /// App executable name or fallback.
    public static func appExecutableName() -> String {
        Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? "UnknownExec"
    }

    /// Build date best-effort using Info.plist file’s modification date.
    public static func appBuildDate() -> Date? {
        if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let attrs = try? FileManager.default.attributesOfItem(atPath: infoPath),
           let date = attrs[.modificationDate] as? Date {
            return date
        }
        return nil
    }

    /// Internal: load a platform image from assets by name.
    public static func cantripLoadImage(named name: String) -> APGCantripImage? {
        
#if canImport(AppKit)
        
        return NSImage(named: NSImage.Name(name))

#elseif canImport(UIKit)

        return UIImage(named: name)

#else

        return nil

#endif
        
    }


    /// User’s Documents directory.
    public static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    /// Temporary directory.
    public static func temporaryDirectory() -> URL {
        FileManager.default.temporaryDirectory
    }

    /// Caches directory.
    public static func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    /// Create directory if missing (ignores errors).
    public static func ensureDirectory(_ url: URL) {
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    /// System uptime (seconds).
    public static func systemUptime() -> TimeInterval {
        ProcessInfo.processInfo.systemUptime
    }

    /// Physical memory (MB).
    public static func physicalMemoryMB() -> Int {
        Int(ProcessInfo.processInfo.physicalMemory / (1024 * 1024))
    }

    /// Logical processor count.
    public static func processorCount() -> Int {
        ProcessInfo.processInfo.processorCount
    }

    /// Hostname (best effort).
    public static func hostname() -> String {
        Host.current().localizedName ?? "UnknownHost"
    }

    /// Simple online check via SystemConfiguration reachability.
    public static func isOnline() -> Bool {
        
#if canImport(SystemConfiguration)
        
        guard let reach = SCNetworkReachabilityCreateWithName(nil, "apple.com") else { return false }
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(reach, &flags) else { return false }
        let reachable = flags.contains(.reachable)
        let requiresConn = flags.contains(.connectionRequired)
        return reachable && !requiresConn
        
#else
        
        // Fallback: assume online unknown
        return true
        
#endif
        
    }

    // MARK: Notifications (modern UNUserNotificationCenter)

    /// Deliver a simple user notification (modern API).
    @MainActor
    public static func deliverNotification(title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: nil)
            center.add(request, withCompletionHandler: nil)
        }
    }

    // MARK: - Appkit Only

#if canImport(AppKit)

    // MARK: Checkers

    /// Returns true if `string` looks like a URL (http/https/ftp).
    public static func isURL(_ string: String) -> Bool {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: trimmed),
              let scheme = url.scheme?.lowercased(),
              ["http", "https", "ftp"].contains(scheme) else { return false }
        return true
    }

    /// Returns true if `path` is a local file that exists **and** has an allowed extension.
    public static func isFileRef(_ path: String) -> Bool {
        let trimmed = path.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        // Expand ~
        let expanded = (trimmed as NSString).expandingTildeInPath
        let url = URL(fileURLWithPath: expanded)

        // Allowed extensions (all lowercase)
        let allowedExtensions: Set<String> = ["pdf", "txt", "mpg", "jpg", "jpeg", "rtf"]

        let ext = url.pathExtension.lowercased()
        guard !ext.isEmpty else { return false }
        guard allowedExtensions.contains(ext) else { return false }

        // Check if file exists
        return FileManager.default.fileExists(atPath: url.path)
    }

    // MARK: Openers

    /// Open only if the text is a URL. Ignores non-URLs.
    @MainActor
    public static func openURLRef(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isURL(trimmed), let url = URL(string: trimmed) else { return }
        NSWorkspace.shared.open(url)
    }

    /// Open a file reference if it exists and has allowed extension.
    @MainActor
    public static func openFileRef(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isFileRef(trimmed) else { return }

        // First try embedded resource by exact name (no extension splitting).
        if let resourceURL = Bundle.main.url(forResource: trimmed, withExtension: nil),
           FileManager.default.fileExists(atPath: resourceURL.path) {
            NSWorkspace.shared.open(resourceURL)
            return
        }

        // Fallback to path on disk
        let expanded = (trimmed as NSString).expandingTildeInPath
        let fileURL = URL(fileURLWithPath: expanded)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            NSWorkspace.shared.open(fileURL)
        }
    }

    /// Open either a URL or an allowed local file.
    @MainActor
    public static func openRef(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if isURL(trimmed) {
            openURLRef(trimmed)
        } else if isFileRef(trimmed) {
            openFileRef(trimmed)
        }
    }

    // MARK: Finder

    /// Reveal a file or directory in Finder.
    @MainActor
    public static func revealInFinder(_ path: String) {
        let url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    // MARK: Clipboard

    /// Copy text to clipboard.
    @MainActor
    public static func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    /// Paste text from clipboard.
    @MainActor
    public static func pasteFromClipboard() -> String? {
        NSPasteboard.general.string(forType: .string)
    }

    // MARK: Alerts

    /// Show a non-blocking alert with a message (scheduled on main actor).
    public static func showMessage(_ text: String) {
        Task { @MainActor in
            let alert = NSAlert()
            alert.messageText = text
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }

    /// Show a blocking alert (call from main actor or `await` it from elsewhere).
    @MainActor
    public static func showBlockingMessage(_ text: String) {
        let alert = NSAlert()
        alert.messageText = text
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    // MARK: UI / App

    /// Get the app’s icon image, if available.
    @MainActor
    public static func appIcon() -> NSImage? {
        NSApp?.applicationIconImage
    }

    /// Set or clear the Dock tile’s badge text.
    @MainActor
    public static func setDockBadge(_ text: String?) {
        NSApp?.dockTile.badgeLabel = text
    }

    /// Current macOS username.
    public static func currentUsername() -> String {
        NSUserName()
    }

    /// Get the main screen size (or `.zero` if unavailable).
    public static func mainScreenSize() -> CGSize {
        NSScreen.main?.frame.size ?? .zero
    }

    /// Get sizes of all attached screens.
    public static func allScreenSizes() -> [CGSize] {
        NSScreen.screens.map { $0.frame.size }
    }

    /// Get current mouse location in screen coordinates.
    public static func mouseLocation() -> CGPoint {
        NSEvent.mouseLocation
    }

    /// Get current modifier flags (Command, Option, Shift, etc.).
    public static func currentModifierFlags() -> NSEvent.ModifierFlags {
        NSEvent.modifierFlags
    }

    // MARK: System / Power

    /// Prevent the system display from sleeping (returns assertion ID when successful).
    public static func preventSleep() -> IOPMAssertionID? {
        var assertionID: IOPMAssertionID = 0
        let reason = "Prevent sleep for critical task" as CFString
        let result = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                 IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                 reason,
                                                 &assertionID)
        return (result == kIOReturnSuccess) ? assertionID : nil
    }

    /// Allow sleep again by releasing the assertion.
    public static func allowSleep(_ id: IOPMAssertionID) {
        IOPMAssertionRelease(id)
    }

    // MARK: Sounds & Speech

    /// Play a built-in system sound by name (e.g., "Glass", "Basso", "Ping").
    public static func playSystemSound(_ name: String) {
        NSSound(named: NSSound.Name(name))?.play()
    }

    /// Speak the given text aloud using system speech.
    public static func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    /// Simple “beep” using a built-in alert sound.
    public static func beep() {
        if NSSound(named: NSSound.Name("Funk"))?.play() != true {
            NSSound(named: NSSound.Name("Basso"))?.play()
        }
    }

    // MARK: Security / Privacy

    /// True if running in App Sandbox.
    public static func isSandboxed() -> Bool {
        ProcessInfo.processInfo.environment["APP_SANDBOX_CONTAINER_ID"] != nil
    }

    // MARK: AppleScript

    /// Run an AppleScript snippet. Prints error to console on failure.
    public static func runAppleScript(_ script: String) {
        if let appleScript = NSAppleScript(source: script) {
            var errorDict: NSDictionary?
            appleScript.executeAndReturnError(&errorDict)
            if let error = errorDict {
                print("AppleScript error: \(error)")
            }
        }
    }

#endif
}
