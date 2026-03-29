import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/app_initialization_service.dart';
import 'demo_data_service.dart';

final demoDataServiceProvider = Provider<DemoDataService>((ref) {
  final db = ref.watch(databaseProvider);
  return DemoDataService(db);
});

class DemoDataNotifier extends StateNotifier<AsyncValue<bool>> {
  final DemoDataService _service;

  DemoDataNotifier(this._service) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final enabled = await _service.isEnabled();
    state = AsyncValue.data(enabled);
  }

  Future<void> toggle(bool enabled) async {
    if (enabled) {
      await _service.seedIfNeeded();
      state = const AsyncValue.data(true);
    } else {
      await _service.setDemoEnabled(false);
      state = const AsyncValue.data(false);
    }
  }
}

final demoDataProvider = StateNotifierProvider<DemoDataNotifier, AsyncValue<bool>>((ref) {
  final service = ref.watch(demoDataServiceProvider);
  return DemoDataNotifier(service);
});
