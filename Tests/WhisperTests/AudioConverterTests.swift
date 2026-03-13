import Foundation
import Testing

@testable import Whisper

@Suite("AudioConverter Tests")
struct AudioConverterTests {
    @Test("Throws fileNotFound for missing file")
    func fileNotFound() throws {
        #expect(throws: WhisperError.self) {
            try AudioConverter.convert(fileAt: "/nonexistent/file.ogg")
        }
    }

    @Test("Throws unsupportedFormat for unknown extension")
    func unsupportedFormat() throws {
        let tempFile = FileManager.default.temporaryDirectory
            .appendingPathComponent("test.xyz")
        FileManager.default.createFile(atPath: tempFile.path, contents: Data())
        defer { try? FileManager.default.removeItem(at: tempFile) }

        #expect(throws: WhisperError.self) {
            try AudioConverter.convert(fileAt: tempFile.path)
        }
    }

    @Test("Returns original path for natively supported formats")
    func nativelySupportedFormats() throws {
        for ext in ["mp3", "m4a", "wav"] {
            let tempFile = FileManager.default.temporaryDirectory
                .appendingPathComponent("test.\(ext)")
            FileManager.default.createFile(atPath: tempFile.path, contents: Data())
            defer { try? FileManager.default.removeItem(at: tempFile) }

            let result = try AudioConverter.convert(fileAt: tempFile.path)
            #expect(result.isTemporary == false)
            #expect(result.url == tempFile)
        }
    }

    @Test("Cleanup removes temporary files")
    func cleanupTemporaryFile() throws {
        let tempFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".wav")
        FileManager.default.createFile(atPath: tempFile.path, contents: Data())

        let result = ConversionResult(url: tempFile, isTemporary: true)
        AudioConverter.cleanUp(result)

        #expect(!FileManager.default.fileExists(atPath: tempFile.path))
    }

    @Test("Cleanup does not remove non-temporary files")
    func cleanupNonTemporaryFile() throws {
        let tempFile = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".mp3")
        FileManager.default.createFile(atPath: tempFile.path, contents: Data())
        defer { try? FileManager.default.removeItem(at: tempFile) }

        let result = ConversionResult(url: tempFile, isTemporary: false)
        AudioConverter.cleanUp(result)

        #expect(FileManager.default.fileExists(atPath: tempFile.path))
    }
}
