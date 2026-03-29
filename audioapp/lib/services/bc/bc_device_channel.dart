import 'package:flutter/services.dart';
import 'bone_conduction_device.dart';

/// Platform channel implementation for BC device control.
class BoneConductionDeviceChannel implements BoneConductionDevice {
  static const MethodChannel _channel = MethodChannel('audioapp/bc_device');

  bool _connected = false;

  @override
  Future<void> connect() async {
    final result = await _channel.invokeMethod<bool>('connect');
    _connected = result ?? false;
  }

  @override
  Future<void> disconnect() async {
    await _channel.invokeMethod<void>('disconnect');
    _connected = false;
  }

  @override
  Future<bool> get isConnected async => _connected;

  @override
  Future<BoneConductionDeviceInfo?> getDeviceInfo() async {
    final data = await _channel.invokeMapMethod<String, dynamic>(
      'getDeviceInfo',
    );
    if (data == null) return null;
    return BoneConductionDeviceInfo(
      id: data['id']?.toString() ?? 'unknown',
      name: data['name']?.toString() ?? 'Unknown Device',
      vendor: data['vendor']?.toString() ?? 'Unknown Vendor',
      model: data['model']?.toString() ?? 'Unknown Model',
      firmware: data['firmware']?.toString(),
    );
  }

  @override
  Future<void> playTone({
    required int frequency,
    required int intensityDbHl,
    required String ear,
    int durationMs = 1500,
  }) async {
    await _channel.invokeMethod<void>('playTone', {
      'frequency': frequency,
      'intensityDbHl': intensityDbHl,
      'ear': ear,
      'durationMs': durationMs,
    });
  }

  @override
  Future<void> stopTone() async {
    await _channel.invokeMethod<void>('stopTone');
  }
}
