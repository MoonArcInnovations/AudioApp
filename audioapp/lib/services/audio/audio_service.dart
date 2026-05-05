import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/app_constants.dart';

/// Audio service for generating pure tones for audiometry testing
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  /// Initialize the audio service
  Future<void> initialize() async {
    _audioPlayer = AudioPlayer();
  }

  /// Check if tone is currently playing
  bool get isPlaying => _isPlaying;

  /// Play a pure tone at specified frequency and intensity
  /// [frequency] - Frequency in Hz (250-8000)
  /// [intensityDbHl] - Intensity in dB HL (-10 to 100)
  /// [ear] - Which ear to play (left/right)
  /// [durationMs] - Duration of tone in milliseconds
  Future<void> playTone({
    required int frequency,
    required int intensityDbHl,
    required Ear ear,
    int durationMs = 1500,
  }) async {
    if (_audioPlayer == null) {
      await initialize();
    }

    _isPlaying = true;

    try {
      // Generate tone data
      final audioData = _generateToneData(
        frequency: frequency,
        intensityDbHl: intensityDbHl,
        durationMs: durationMs,
        ear: ear,
      );

      // Create audio source from bytes
      final audioSource = _PureToneAudioSource(
        audioData,
        duration: Duration(milliseconds: durationMs),
      );

      await _audioPlayer!.setAudioSource(audioSource);
      await _audioPlayer!.play();

      // Wait for tone to complete
      await Future.delayed(Duration(milliseconds: durationMs + 100));
    } catch (e) {
      debugPrint('Error playing tone: $e');
    } finally {
      _isPlaying = false;
    }
  }

  /// Stop any currently playing tone
  Future<void> stopTone() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      _isPlaying = false;
    }
  }

  /// Generate WAV audio data for a pure tone
  Uint8List _generateToneData({
    required int frequency,
    required int intensityDbHl,
    required int durationMs,
    required Ear ear,
  }) {
    const sampleRate = AppConstants.sampleRate;
    final numSamples = (sampleRate * durationMs / 1000).round();

    // Convert dB HL to amplitude (0.0 - 1.0)
    final amplitude = _dbHlToAmplitude(intensityDbHl, frequency);

    // Generate stereo samples (left, right interleaved)
    final samples = List<int>.filled(numSamples * 2, 0);

    // Fade in/out duration (50ms)
    final fadeInSamples = (sampleRate * 0.05).round();
    final fadeOutStart = numSamples - fadeInSamples;

    for (var i = 0; i < numSamples; i++) {
      // Calculate sine wave
      final time = i / sampleRate;
      var sampleValue = (amplitude * sin(2 * pi * frequency * time) * 32767)
          .round();

      // Apply fade in
      if (i < fadeInSamples) {
        sampleValue = (sampleValue * (i / fadeInSamples)).round();
      }
      // Apply fade out
      else if (i >= fadeOutStart) {
        sampleValue = (sampleValue * ((numSamples - i) / fadeInSamples))
            .round();
      }

      // Clamp to 16-bit range
      sampleValue = sampleValue.clamp(-32768, 32767);

      // Set sample for appropriate ear (stereo: left, right interleaved)
      final leftIndex = i * 2;
      final rightIndex = i * 2 + 1;

      if (ear == Ear.left) {
        samples[leftIndex] = sampleValue;
        samples[rightIndex] = 0;
      } else if (ear == Ear.right) {
        samples[leftIndex] = 0;
        samples[rightIndex] = sampleValue;
      }
    }

    // Create WAV file data
    return _createWavData(samples, sampleRate);
  }

  /// Convert dB HL to amplitude (0.0 to 1.0)
  double _dbHlToAmplitude(int dbHl, int frequency) {
    // Get RETSPL value for this frequency
    final retspl = AppConstants.retsplValues[frequency] ?? 10.0;

    // Convert dB HL to dB SPL
    final dbSpl = dbHl + retspl;

    // Convert dB SPL to linear amplitude
    // Using 94 dB SPL as reference (1 Pascal)
    // Clamped to reasonable range for mobile device output
    final amplitude = pow(10, (dbSpl - 94) / 20).toDouble();

    // Clamp to safe range (0.0 - 0.8 to prevent distortion)
    return amplitude.clamp(0.001, 0.8);
  }

  /// Create WAV file from samples
  Uint8List _createWavData(List<int> samples, int sampleRate) {
    final numChannels = 2;
    final bitsPerSample = 16;
    final byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;
    final blockAlign = numChannels * bitsPerSample ~/ 8;
    final dataSize = samples.length * 2;
    final fileSize = 36 + dataSize;

    final buffer = ByteData(44 + dataSize);

    // RIFF header
    buffer.setUint8(0, 0x52); // 'R'
    buffer.setUint8(1, 0x49); // 'I'
    buffer.setUint8(2, 0x46); // 'F'
    buffer.setUint8(3, 0x46); // 'F'
    buffer.setUint32(4, fileSize, Endian.little);
    buffer.setUint8(8, 0x57); // 'W'
    buffer.setUint8(9, 0x41); // 'A'
    buffer.setUint8(10, 0x56); // 'V'
    buffer.setUint8(11, 0x45); // 'E'

    // fmt chunk
    buffer.setUint8(12, 0x66); // 'f'
    buffer.setUint8(13, 0x6D); // 'm'
    buffer.setUint8(14, 0x74); // 't'
    buffer.setUint8(15, 0x20); // ' '
    buffer.setUint32(16, 16, Endian.little); // Chunk size
    buffer.setUint16(20, 1, Endian.little); // Audio format (PCM)
    buffer.setUint16(22, numChannels, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, byteRate, Endian.little);
    buffer.setUint16(32, blockAlign, Endian.little);
    buffer.setUint16(34, bitsPerSample, Endian.little);

    // data chunk
    buffer.setUint8(36, 0x64); // 'd'
    buffer.setUint8(37, 0x61); // 'a'
    buffer.setUint8(38, 0x74); // 't'
    buffer.setUint8(39, 0x61); // 'a'
    buffer.setUint32(40, dataSize, Endian.little);

    // Write samples
    var offset = 44;
    for (final sample in samples) {
      buffer.setInt16(offset, sample, Endian.little);
      offset += 2;
    }

    return buffer.buffer.asUint8List();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}

/// Custom audio source for playing generated tone data
class _PureToneAudioSource extends StreamAudioSource {
  final Uint8List _audioData;
  final Duration _duration;

  _PureToneAudioSource(this._audioData, {required Duration duration})
    : _duration = duration;

  @override
  Duration get duration => _duration;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _audioData.length;

    return StreamAudioResponse(
      sourceLength: _audioData.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_audioData.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}
