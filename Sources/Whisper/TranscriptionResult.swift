import Foundation

public struct TranscriptionSegment: Codable, Sendable {
    public let text: String
    public let startTime: Double
    public let endTime: Double

    public init(text: String, startTime: Double, endTime: Double) {
        self.text = text
        self.startTime = startTime
        self.endTime = endTime
    }
}

public struct TranscriptionResult: Codable, Sendable {
    public let text: String
    public let segments: [TranscriptionSegment]
    public let detectedLanguage: String?
    public let durationSeconds: Double?

    public init(
        text: String,
        segments: [TranscriptionSegment],
        detectedLanguage: String? = nil,
        durationSeconds: Double? = nil
    ) {
        self.text = text
        self.segments = segments
        self.detectedLanguage = detectedLanguage
        self.durationSeconds = durationSeconds
    }
}

public struct ErrorResult: Codable, Sendable {
    public let error: String
    public let code: Int32

    public init(error: String, code: Int32) {
        self.error = error
        self.code = code
    }
}
