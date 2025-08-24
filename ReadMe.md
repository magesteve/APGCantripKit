# APGCantripKit

A lightweight Swift library of **properties, typealiases, and common functions** that are useful across Apple platform development.
Think of them as **“cantrips”**: small, reusable bits of functionality that you’ll find yourself using again and again.

**Current version 0.1.0**

---

## ✨ Features

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

- **macOS UI Utilities** *(guarded with `#if os(macOS)`)*
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

---

## 📦 Installation

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

## 🚀 Usage

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

#if os(macOS)
APGCantrip.showMessage("Hello, world!")
#endif
```

---

## 🧪 Testing

Unit tests are written using **Swift Testing** (`import Testing`).

Run with:

```bash
swift test
```

---

## 📄 License

MIT License.
Created by **Steve Sheets**, 2025.
