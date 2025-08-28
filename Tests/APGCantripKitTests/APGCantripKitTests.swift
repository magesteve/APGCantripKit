import Testing
import Foundation
@testable import APGCantripKit

// MARK: - URL checks

@Test func urlDetection_MoreCases() async throws {
    // Positives
    #expect(APGCantrip.isURL("http://example.com"))
    #expect(APGCantrip.isURL("https://apple.com/path?x=1#frag"))
    #expect(APGCantrip.isURL("FTP://fileserver.com/dir/file"))   // case-insensitive scheme

    // Negatives
    #expect(!APGCantrip.isURL("not a url"))
    #expect(!APGCantrip.isURL("example.com"))                     // missing scheme
    #expect(!APGCantrip.isURL("/Users/steve/file.pdf"))           // local path
    #expect(!APGCantrip.isURL("mailto:me@example.com"))           // unsupported scheme
    #expect(!APGCantrip.isURL(" file://localhost/thing"))         // leading space (trim will fix, but scheme not allowed)
}

// MARK: - FileRef checks (allowed extensions + existence)

@Test func fileDetection_NonExisting() async throws {
    let fakeFile = FileManager.default.temporaryDirectory.appendingPathComponent("nonexistent.pdf")
    #expect(!APGCantrip.isFileRef(fakeFile.path))
}

@Test func fileDetection_DisallowedExtension() async throws {
    let tempDir = FileManager.default.temporaryDirectory
    let bad = tempDir.appendingPathComponent("testFile.exe")
    FileManager.default.createFile(atPath: bad.path, contents: Data(), attributes: nil)
    defer { try? FileManager.default.removeItem(at: bad) }

    #expect(!APGCantrip.isFileRef(bad.path))
}

@Test func fileDetection_Allowed_txt() async throws {
    let tempDir = FileManager.default.temporaryDirectory
    let f = tempDir.appendingPathComponent("cantrip-\(UUID().uuidString).txt")
    try "hello".write(to: f, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: f) }

    #expect(APGCantrip.isFileRef(f.path))
}

@Test func fileDetection_Allowed_jpg() async throws {
    let tempDir = FileManager.default.temporaryDirectory
    let f = tempDir.appendingPathComponent("img-\(UUID().uuidString).jpg")
    FileManager.default.createFile(atPath: f.path, contents: Data([0xFF, 0xD8, 0xFF]), attributes: nil) // JPEG SOI bytes
    defer { try? FileManager.default.removeItem(at: f) }

    #expect(APGCantrip.isFileRef(f.path))
}

@Test func fileDetection_UppercaseExtension_PDF() async throws {
    let tempDir = FileManager.default.temporaryDirectory
    let f = tempDir.appendingPathComponent("Doc-\(UUID().uuidString).PDF")
    FileManager.default.createFile(atPath: f.path, contents: Data(), attributes: nil)
    defer { try? FileManager.default.removeItem(at: f) }

    #expect(APGCantrip.isFileRef(f.path))
}

@Test func fileDetection_NoExtension() async throws {
    let tempDir = FileManager.default.temporaryDirectory
    let f = tempDir.appendingPathComponent("noext-\(UUID().uuidString)")
    FileManager.default.createFile(atPath: f.path, contents: Data(), attributes: nil)
    defer { try? FileManager.default.removeItem(at: f) }

    #expect(!APGCantrip.isFileRef(f.path))
}

// Using tilde path expansion (~)
@Test func fileDetection_TildePath_txt() async throws {
    // Create in home directory
    let home = FileManager.default.homeDirectoryForCurrentUser
    let filename = "cantrip-home-\(UUID().uuidString).txt"
    let f = home.appendingPathComponent(filename)
    try "home".write(to: f, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: f) }

    let tildePath = "~/" + filename
    #expect(APGCantrip.isFileRef(tildePath))
}

// MARK: - Directories / FS helpers

@Test func directories_Exist() async throws {
    let docs = APGCantrip.documentsDirectory()
    let tmp  = APGCantrip.temporaryDirectory()
    let caches = APGCantrip.cachesDirectory()

    #expect(FileManager.default.fileExists(atPath: docs.path))
    #expect(FileManager.default.fileExists(atPath: tmp.path))
    #expect(FileManager.default.fileExists(atPath: caches.path))
}

@Test func ensureDirectory_CreatesIfMissing() async throws {
    let base = APGCantrip.temporaryDirectory()
    let newDir = base.appendingPathComponent("cantrip-dir-\(UUID().uuidString)")
    defer { try? FileManager.default.removeItem(at: newDir) }

    // Ensure doesn't exist
    #expect(!FileManager.default.fileExists(atPath: newDir.path))

    APGCantrip.ensureDirectory(newDir)

    var isDir: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: newDir.path, isDirectory: &isDir)
    #expect(exists && isDir.boolValue)
}

// MARK: - App / Bundle info

@Test func appInfo_Basics() async throws {
    let name = APGCantrip.appName()
    let bundleID = APGCantrip.appBundleID()
    let ver = APGCantrip.appVersionString()
    let about = APGCantrip.aboutString()

    #expect(!name.isEmpty)
    #expect(!bundleID.isEmpty)
    #expect(ver.contains("v"))    // "vX (Y)" format
    #expect(!about.isEmpty)
}

@Test func systemInfo_Basics() async throws {
    #expect(APGCantrip.processorCount() >= 1)
    #expect(APGCantrip.physicalMemoryMB() > 0)
    #expect(APGCantrip.systemUptime() >= 0)
    #expect(!APGCantrip.hostname().isEmpty)
}

