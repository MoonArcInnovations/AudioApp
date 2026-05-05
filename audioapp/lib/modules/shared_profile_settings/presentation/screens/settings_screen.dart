import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/entities/shared_settings.dart';
import '../providers/shared_settings_providers.dart';
import '../view_models/shared_settings_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _headphoneOptions = <String>[
    'TDH-39 Supra-aural',
    'HDA 300 Circum-aural',
    'ER-3A Insert',
    'Consumer Headphones',
  ];

  static const _toneDurations = <int>[500, 1000, 1500, 2000];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelAsync = ref.watch(sharedSettingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: viewModelAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Unable to load settings: $error'),
          ),
        ),
        data: (viewModel) => ListView(
          children: [
            _buildSectionHeader(context, 'Appearance'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Theme'),
                    subtitle: Text(viewModel.themeLabel),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeDialog(context, ref, viewModel),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.text_fields),
                    title: const Text('Text Size'),
                    subtitle: const Text('System default'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showInfoSnackBar(
                      context,
                      'Text size follows the device setting in this build.',
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(context, 'Notifications'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.alarm),
                    title: const Text('Test Reminders'),
                    subtitle: const Text('Notify when tests are due'),
                    value: viewModel.settings.notifications.testReminders,
                    onChanged: (_) => ref
                        .read(sharedSettingsControllerProvider.notifier)
                        .toggleNotification('testReminders'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    secondary: const Icon(Icons.person),
                    title: const Text('Patient Updates'),
                    subtitle: const Text('Notify on patient changes'),
                    value: viewModel.settings.notifications.patientUpdates,
                    onChanged: (_) => ref
                        .read(sharedSettingsControllerProvider.notifier)
                        .toggleNotification('patientUpdates'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    secondary: const Icon(Icons.sync),
                    title: const Text('Sync Notifications'),
                    subtitle: const Text('Notify on sync completion'),
                    value: viewModel.settings.notifications.syncNotifications,
                    onChanged: (_) => ref
                        .read(sharedSettingsControllerProvider.notifier)
                        .toggleNotification('syncNotifications'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up),
                    title: const Text('Sound'),
                    value: viewModel.settings.notifications.soundEnabled,
                    onChanged: (_) => ref
                        .read(sharedSettingsControllerProvider.notifier)
                        .toggleNotification('soundEnabled'),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(context, 'Audio Settings'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.headphones),
                    title: const Text('Default Headphone'),
                    subtitle: Text(viewModel.settings.defaultHeadphone),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showHeadphoneDialog(context, ref, viewModel),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: const Text('Calibration'),
                    subtitle: Text(
                      viewModel.canOpenCalibration
                          ? 'Open calibration tools'
                          : 'Available for audiologists',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: viewModel.canOpenCalibration
                        ? () => context.push(AppRoutes.audiologistCalibration)
                        : null,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text('Tone Duration'),
                    subtitle: Text('${viewModel.settings.toneDurationMs} ms'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        _showToneDurationDialog(context, ref, viewModel),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(context, 'Data & Storage'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.auto_fix_high),
                    title: const Text('Seed Demo Data'),
                    subtitle: const Text('Populate sample patients and tests'),
                    value: viewModel.settings.demoDataEnabled,
                    onChanged: (value) async {
                      await ref
                          .read(sharedSettingsControllerProvider.notifier)
                          .setDemoDataEnabled(value);
                      if (context.mounted && !value) {
                        _showInfoSnackBar(
                          context,
                          'Demo data disabled. Existing records were kept.',
                        );
                      }
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.cloud_sync),
                    title: const Text('Cloud Sync'),
                    subtitle: Text(viewModel.syncSubtitle),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        await ref
                            .read(sharedSettingsControllerProvider.notifier)
                            .syncNow();
                        if (context.mounted) {
                          _showInfoSnackBar(context, 'Sync finished.');
                        }
                      },
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Local Storage'),
                    subtitle: Text(viewModel.storageSubtitle),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Export Data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showInfoSnackBar(
                      context,
                      'Export workflows are moving into a dedicated module.',
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionHeader(context, 'About'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Version'),
                    trailing: Text('1.0.0'),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showInfoSnackBar(
                      context,
                      'Terms of Service is not wired yet.',
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showInfoSnackBar(
                      context,
                      'Privacy Policy is not wired yet.',
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showInfoSnackBar(
                      context,
                      'Help & Support is not wired yet.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    SharedSettingsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Theme'),
        children: ThemeModePreference.values
            .map(
              (mode) => ListTile(
                title: Text(mode.label),
                trailing: viewModel.settings.themeMode == mode
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  await ref
                      .read(sharedSettingsControllerProvider.notifier)
                      .setThemeMode(mode);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showHeadphoneDialog(
    BuildContext context,
    WidgetRef ref,
    SharedSettingsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Headphone Type'),
        children: _headphoneOptions
            .map(
              (option) => ListTile(
                title: Text(option),
                trailing: viewModel.settings.defaultHeadphone == option
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  await ref
                      .read(sharedSettingsControllerProvider.notifier)
                      .setDefaultHeadphone(option);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showToneDurationDialog(
    BuildContext context,
    WidgetRef ref,
    SharedSettingsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tone Duration'),
        children: _toneDurations
            .map(
              (duration) => ListTile(
                title: Text('$duration ms'),
                trailing: viewModel.settings.toneDurationMs == duration
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  await ref
                      .read(sharedSettingsControllerProvider.notifier)
                      .setToneDuration(duration);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
