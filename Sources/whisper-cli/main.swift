import ArgumentParser
import Foundation
import Whisper

@main
struct WhisperCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "whisper",
        abstract: "Local speech-to-text transcription using Apple SpeechAnalyzer"
    )

    @Argument(help: "Path to the audio file to transcribe")
    var inputPath: String

    @Option(help: "Locale hint for speech recognition (e.g. zh-Hans, en-US)")
    var locale: String?

    @Flag(help: "Output plain text instead of JSON")
    var plain: Bool = false

    func run() async throws {
        var conversionResult: ConversionResult?
        defer {
            if let conversionResult {
                AudioConverter.cleanUp(conversionResult)
            }
        }

        do {
            conversionResult = try AudioConverter.convert(fileAt: inputPath)

            let speechLocale = locale.map { Locale(identifier: $0) }
            let result = try await Transcriber.transcribe(
                audioURL: conversionResult!.url,
                locale: speechLocale
            )

            if plain {
                print(result.text)
            } else {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let data = try encoder.encode(result)
                print(String(data: data, encoding: .utf8)!)
            }
        } catch let error as WhisperError {
            outputError(error)
            throw ExitCode(error.exitCode)
        } catch {
            let wrapped = WhisperError.systemError(error.localizedDescription)
            outputError(wrapped)
            throw ExitCode(wrapped.exitCode)
        }
    }

    private func outputError(_ error: WhisperError) {
        let errorResult = ErrorResult(
            error: error.errorDescription ?? "Unknown error",
            code: error.exitCode
        )
        if let data = try? JSONEncoder().encode(errorResult),
           let json = String(data: data, encoding: .utf8) {
            FileHandle.standardError.write(Data((json + "\n").utf8))
        }
    }
}
