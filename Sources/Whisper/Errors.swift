import Foundation

public enum WhisperError: LocalizedError {
    case fileNotFound(String)
    case unsupportedFormat(String)
    case conversionFailed(String)
    case transcriptionFailed(String)
    case systemError(String)

    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            "File not found: \((path as NSString).lastPathComponent)"
        case .unsupportedFormat(let ext):
            "Unsupported audio format: \(ext)"
        case .conversionFailed(let reason):
            "Audio conversion failed: \(reason)"
        case .transcriptionFailed(let reason):
            "Transcription failed: \(reason)"
        case .systemError(let reason):
            "System error: \(reason)"
        }
    }

    public var exitCode: Int32 {
        switch self {
        case .fileNotFound, .unsupportedFormat: 1
        case .conversionFailed: 2
        case .transcriptionFailed: 3
        case .systemError: 4
        }
    }
}
