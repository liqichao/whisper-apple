# Whisper Apple

Local speech-to-text CLI powered by Apple SpeechAnalyzer. Runs entirely offline on macOS — no cloud APIs needed.

本地语音转文字命令行工具，基于 Apple SpeechAnalyzer，完全离线运行，无需云端 API。

## Requirements / 系统要求

- macOS 26+ (Tahoe)

## Installation / 安装

### Homebrew (Recommended / 推荐)

```bash
brew tap liqichao/tap
brew install whisper-apple
```

### Build from Source / 从源码构建

```bash
git clone https://github.com/liqichao/whisper-apple.git
cd whisper-apple
swift build -c release
# The binary is at .build/release/whisper
# Install to PATH:
sudo cp .build/release/whisper /usr/local/bin/whisper-apple
```

## Usage / 用法

```bash
# JSON output (default / 默认 JSON 输出)
whisper-apple /path/to/audio.ogg

# Plain text output / 纯文本输出
whisper-apple --plain /path/to/audio.ogg

# Specify locale / 指定语言
whisper-apple --locale zh-Hans /path/to/audio.ogg
whisper-apple --locale en-US /path/to/audio.wav
```

## Supported Formats / 支持格式

| Format | Extensions | Handling |
|--------|-----------|----------|
| OGG Opus | `.ogg` `.oga` `.opus` | Auto-converted to WAV / 自动转码为 WAV |
| MP3 | `.mp3` | Direct / 直接识别 |
| AAC/M4A | `.m4a` `.aac` | Direct / 直接识别 |
| WAV/AIFF/CAF | `.wav` `.aiff` `.caf` | Direct / 直接识别 |

## Output / 输出

### JSON (default / 默认)

```json
{
  "detectedLanguage": "zh-Hans",
  "durationSeconds": 3.5,
  "segments": [{ "text": "今天天气真好", "startTime": 0, "endTime": 0 }],
  "text": "今天天气真好"
}
```

### Plain text / 纯文本 (`--plain`)

```
今天天气真好
```

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success / 成功 |
| 1 | Input error (file not found, unsupported format) / 输入错误 |
| 2 | Audio conversion failed / 音频转换失败 |
| 3 | Transcription failed / 转写失败 |
| 4 | System error / 系统错误 |

Errors are output to stderr as JSON: `{"code": 1, "error": "File not found: ..."}`

## OpenClaw Integration / OpenClaw 集成

To use with [OpenClaw](https://github.com/liqichao/OpenClaw) for automatic voice message transcription, add the following to your `openclaw.json` tools config:

```json
"media": {
  "audio": {
    "enabled": true,
    "models": [
      {
        "type": "cli",
        "command": "whisper-apple",
        "args": ["--plain", "{{MediaPath}}"]
      }
    ],
    "timeoutSeconds": 60
  }
}
```

> The binary is named `whisper-apple` to avoid conflicts with OpenAI Whisper.
>
> 二进制命名为 `whisper-apple` 以避免与 OpenAI Whisper 冲突。

## Notes / 注意事项

- First run downloads offline speech recognition models (may take a while).
  首次运行需下载离线语音识别模型，耗时较长。
- OGG files are temporarily converted to WAV; temp files are cleaned up automatically.
  OGG 文件会临时转码为 WAV，转写后自动清理。
- Typical performance: ~5 seconds for 1 minute of audio.
  性能参考：1 分钟音频约 5 秒处理。

## License

MIT
