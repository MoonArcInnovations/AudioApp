import 'package:flutter/foundation.dart';

/// Basic info about a connected BC device.
@immutable
class BoneConductionDeviceInfo {
  final String id;
  final String name;
  final String vendor;
  final String model;
  final String? firmware;

  const BoneConductionDeviceInfo({
    required this.id,
    required this.name,
    required this.vendor,
    required this.model,
    this.firmware,
  });
}

/// Abstract interface for a bone conduction device.
abstract class BoneConductionDevice {
  Future<void> connect();
  Future<void> disconnect();
  Future<bool> get isConnected;

  Future<BoneConductionDeviceInfo?> getDeviceInfo();

  /// Play a BC tone via connected audiometer/transducer.
  /// Implementations must handle calibration and routing.
  Future<void> playTone({
    required int frequency,
    required int intensityDbHl,
    required String ear, // 'left' or 'right'
    int durationMs = 1500,
  });

  Future<void> stopTone();
}
