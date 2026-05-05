import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bone_conduction_device.dart';
import 'bc_device_channel.dart';

/// Provider for the BC device control implementation.
final boneConductionDeviceProvider = Provider<BoneConductionDevice>((ref) {
  return BoneConductionDeviceChannel();
});
