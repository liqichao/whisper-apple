import Foundation
import Testing

@testable import Whisper

@Suite("Transcriber Tests")
struct TranscriberTests {
    @Test("TranscriptionResult encodes to JSON correctly")
    func resultEncoding() throws {
        let result = TranscriptionResult(
            text: "Hello world",
            segments: [
                TranscriptionSegment(text: "Hello", startTime: 0.0, endTime: 0.5),
                TranscriptionSegment(text: "world", startTime: 0.5, endTime: 1.0),
            ],
            detectedLanguage: "en-US",
            durationSeconds: 1.0
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(result)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"text\":\"Hello world\""))
        #expect(json.contains("\"detectedLanguage\":\"en-US\""))
        #expect(json.contains("\"durationSeconds\":1"))
    }

    @Test("ErrorResult encodes correctly")
    func errorResultEncoding() throws {
        let errorResult = ErrorResult(error: "File not found", code: 1)
        let data = try JSONEncoder().encode(errorResult)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"error\":\"File not found\""))
        #expect(json.contains("\"code\":1"))
    }
}
