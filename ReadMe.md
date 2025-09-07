# APGCantripKit

A lightweight Swift library of **properties, typealiases, and common functions** that are useful across Apple platform development.
Think of them as **“cantrips”**: small, reusable bits of functionality that you’ll find yourself using again and again.

Repository https://github.com/magesteve/APGCantripKit with current version **0.6.0**

---

## ✨ Features

### Static Functions

Useful static function call from calss APGCantrip.

- **App Info Helpers**
  - `APGCantrip.version` → package version
  - `appName()`, `appBundleID()`, `appVersionString()`, `aboutString()`
  - `copyrightString()`, `appExecutableName()`, `appBuildDate()`

- **File System Shortcuts**
  - `documentsDirectory()`, `temporaryDirectory()`, `cachesDirectory()`
  - `ensureDirectory(_:)` to auto-create folders
  - `isFileRef(_:)` check for local files with allowed extensions (`pdf`, `txt`, `mpg`, `jpg`, `jpeg`, `rtf`)

- **URL & Network Utilities**
  - `isURL(_:)`, `openURLRef(_:)`, `openRef(_:)`
  - `hostname()`, `isOnline()`

- **macOS UI Utilities** *(guarded with `#if canImport(AppKit)`)*
  - Clipboard: `copyToClipboard(_:)`, `pasteFromClipboard()`
  - Alerts: `showMessage(_:)`, `showBlockingMessage(_:)`
  - Finder: `revealInFinder(_:)`
  - Dock badge: `setDockBadge(_:)`
  - Screen: `mainScreenSize()`, `allScreenSizes()`
  - Input: `mouseLocation()`, `currentModifierFlags()`
  - Notifications: `deliverNotification(title:body:)`
  - Speech & Sound: `speak(_:)`, `playSystemSound(_:)`, `beep()`
  - Power: `preventSleep()`, `allowSleep(_:)`
  - Security: `isSandboxed()`, `hasAccessibilityPermission()`
  - AppleScript: `runAppleScript(_:)`

- **System Info**
  - `systemUptime()`, `processorCount()`, `physicalMemoryMB()`
  - `currentUsername()`
  
### RGB Data

APGCantripRGB is a new structure containing RGBA data, along with function to convert to common Color formats, as well as preset value.

### CSS

APGCantripCSS is a new class containing font information used by Attributed Strings to emulate HTML/CSS usage of Rich Texts.  gAPGCantripCSSDefault is the default global most often used to describe the appearance.

### Rich Text (AttributedString)

APGCantrip+AttributedString contains extension to AttributedString to help the creation of Rich Text content in the style of HTML/CSS.  New function have been added to the AttributedString type to easily add paragraphs, banners and links to an Attributed String.

---

## Installation

Add **APGCantripKit** as a Swift Package dependency in Xcode:

1. In your project, select **File > Add Packages…**
2. Enter the repository URL for APGCantripKit
3. Choose the latest version and add it to your target

Or add directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/APGCantripKit.git", from: "0.1.0")
]
```

---

## Usage

Import the module:

```swift
import APGCantripKit
```

Call helpers directly from the namespace `APGCantrip`:

```swift
print(APGCantrip.version)               // "0.1.0"
print(APGCantrip.appName())             // "MyApp"
print(APGCantrip.aboutString())         // "MyApp v1.0 (1) — © 2025 My Company"

if APGCantrip.isURL("https://apple.com") {
    APGCantrip.openRef("https://apple.com")
}

#if canImport(AppKit)
APGCantrip.showMessage("Hello, world!")
#endif
```

---

## Testing

Unit tests are written using **Swift Testing** (`import Testing`).

Run with:

```bash
swift test
```

---

### Sample Code

The APGExample can be found at [Repository](https://github.com/magesteve/APGExample).

---

## License

[MIT License](LICENSE)
Created by **Steve Sheets**, 2025
