import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/app_initialization_service.dart';
import '../../../../services/demo/demo_data_service.dart';
import '../../domain/repositories/shared_settings_repository.dart';
import '../repositories/local_shared_settings_repository.dart';

final sharedSettingsDemoDataServiceProvider = Provider<DemoDataService>((ref) {
  return DemoDataService(ref.watch(databaseProvider));
});

final sharedSettingsRepositoryProvider = Provider<SharedSettingsRepository>((
  ref,
) {
  return LocalSharedSettingsRepository(
    database: ref.watch(databaseProvider),
    demoDataService: ref.watch(sharedSettingsDemoDataServiceProvider),
  );
});
