import Foundation
import SFBAudioEngine

public struct ConversionResult: Sendable {
    public let url: URL
    public let isTemporary: Bool

    public init(url: URL, isTemporary: Bool) {
        self.url = url
        self.isTemporary = isTemporary
    }
}

public enum AudioConverter {
    private static let nativelySupportedExtensions: Set<String> = ["mp3", "m4a", "wav", "caf", "aac", "aiff"]

    public static func convert(fileAt path: String) throws -> ConversionResult {
        let url = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: path) else {
            throw WhisperError.fileNotFound(path)
        }

        let ext = url.pathExtension.lowercased()

        if nativelySupportedExtensions.contains(ext) {
            return ConversionResult(url: url, isTemporary: false)
        }

        if ext == "ogg" || ext == "oga" || ext == "opus" {
            return try convertToWAV(from: url)
        }

        throw WhisperError.unsupportedFormat(ext)
    }

    private static func convertToWAV(from sourceURL: URL) throws -> ConversionResult {
        let tempDir = FileManager.default.temporaryDirectory
        let outputURL = tempDir.appendingPathComponent(UUID().uuidString + ".wav")

        do {
            try SFBAudioEngine.AudioConverter.convert(sourceURL, to: outputURL)
            return ConversionResult(url: outputURL, isTemporary: true)
        } catch {
            // Clean up partial output on failure
            try? FileManager.default.removeItem(at: outputURL)
            throw WhisperError.conversionFailed(error.localizedDescription)
        }
    }

    public static func cleanUp(_ result: ConversionResult) {
        if result.isTemporary {
            try? FileManager.default.removeItem(at: result.url)
        }
    }
}
