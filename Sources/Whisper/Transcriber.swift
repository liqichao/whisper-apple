import AVFoundation
import Speech

public enum Transcriber {
    public static func transcribe(
        audioURL: URL,
        locale: Locale? = nil
    ) async throws -> TranscriptionResult {
        let audioFile = try AVAudioFile(forReading: audioURL)
        let duration = Double(audioFile.length) / audioFile.fileFormat.sampleRate

        let speechLocale = locale ?? .current
        let transcriber = SpeechTranscriber(locale: speechLocale, preset: .transcription)
        let analyzer = SpeechAnalyzer(modules: [transcriber])

        async let collected: (segments: [TranscriptionSegment], fullText: String) = {
            var segments: [TranscriptionSegment] = []
            var fullText = ""
            for try await result in transcriber.results {
                let text = String(result.text.characters[...])
                segments.append(TranscriptionSegment(
                    text: text,
                    startTime: 0,
                    endTime: 0
                ))
                fullText += text
            }
            return (segments, fullText)
        }()

        if let lastSample = try await analyzer.analyzeSequence(from: audioFile) {
            try await analyzer.finalizeAndFinish(through: lastSample)
        } else {
            await analyzer.cancelAndFinishNow()
        }

        let result = try await collected

        return TranscriptionResult(
            text: result.fullText,
            segments: result.segments,
            detectedLanguage: speechLocale.identifier,
            durationSeconds: duration
        )
    }
}
