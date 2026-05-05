import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/bootstrap/app_bootstrap.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'modules/shared_profile_settings/presentation/providers/shared_settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bootstrapResult = await const AppBootstrap().initialize();

  runApp(ProviderScope(child: AudioApp(initialBootstrapResult: bootstrapResult)));
}

class AudioApp extends ConsumerStatefulWidget {
  const AudioApp({required this.initialBootstrapResult, super.key});

  final AppBootstrapResult initialBootstrapResult;

  @override
  ConsumerState<AudioApp> createState() => _AudioAppState();
}

class _AudioAppState extends ConsumerState<AudioApp> {
  late AppBootstrapResult _bootstrapResult;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _bootstrapResult = widget.initialBootstrapResult;
  }

  Future<void> _retryBootstrap() async {
    setState(() => _isRetrying = true);
    final result = await const AppBootstrap().initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      _bootstrapResult = result;
      _isRetrying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_bootstrapResult.isReady) {
      return MaterialApp(
        title: 'AudioApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: _InitializationErrorScreen(
          result: _bootstrapResult,
          isRetrying: _isRetrying,
          onRetry: _retryBootstrap,
        ),
      );
    }

    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      title: 'AudioApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

/// Error screen shown when initialization fails
class _InitializationErrorScreen extends StatelessWidget {
  const _InitializationErrorScreen({
    required this.result,
    required this.isRetrying,
    required this.onRetry,
  });

  final AppBootstrapResult result;
  final bool isRetrying;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
                const SizedBox(height: 24),
                Text(
                  result.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  result.userMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                if (result.technicalDetails != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    result.technicalDetails!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: isRetrying ? null : onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(isRetrying ? 'Retrying...' : 'Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
