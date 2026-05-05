import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import 'screening_headphone_selection_screen.dart';

/// Environment check screen - verifies ambient noise levels
class ScreeningEnvironmentCheckScreen extends ConsumerStatefulWidget {
  const ScreeningEnvironmentCheckScreen({super.key});

  @override
  ConsumerState<ScreeningEnvironmentCheckScreen> createState() => _ScreeningEnvironmentCheckScreenState();
}

class _ScreeningEnvironmentCheckScreenState extends ConsumerState<ScreeningEnvironmentCheckScreen> {
  _EnvironmentStatus _status = _EnvironmentStatus.checking;
  double _noiseLevel = 0;
  double _averageNoise = 0;
  final List<double> _noiseSamples = [];
  Timer? _checkTimer;
  int _checkDuration = 0;
  static const int _requiredCheckDuration = 5; // seconds
  
  // Thresholds
  static const double _goodThreshold = 35.0;
  static const double _acceptableThreshold = 45.0;

  @override
  void initState() {
    super.initState();
    _startEnvironmentCheck();
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  void _startEnvironmentCheck() {
    setState(() {
      _status = _EnvironmentStatus.checking;
      _noiseSamples.clear();
      _checkDuration = 0;
    });

    // Simulate noise monitoring (replace with actual audio service)
    _checkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // Simulated noise level - in production, use actual microphone input
      final simulatedNoise = 30.0 + (DateTime.now().millisecond % 20);
      
      setState(() {
        _noiseLevel = simulatedNoise;
        _noiseSamples.add(simulatedNoise);
        
        if (_noiseSamples.isNotEmpty) {
          _averageNoise = _noiseSamples.reduce((a, b) => a + b) / _noiseSamples.length;
        }
      });

      if (_noiseSamples.length >= _requiredCheckDuration * 2) {
        timer.cancel();
        _evaluateEnvironment();
      } else {
        setState(() {
          _checkDuration = (_noiseSamples.length / 2).floor();
        });
      }
    });
  }

  void _evaluateEnvironment() {
    setState(() {
      if (_averageNoise <= _goodThreshold) {
        _status = _EnvironmentStatus.good;
      } else if (_averageNoise <= _acceptableThreshold) {
        _status = _EnvironmentStatus.acceptable;
      } else {
        _status = _EnvironmentStatus.tooNoisy;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment Check'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: _buildContent(),
              ),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Noise level indicator
        _buildNoiseLevelIndicator(),
        
        const SizedBox(height: 32),
        
        // Status message
        _buildStatusMessage(),
        
        const SizedBox(height: 24),
        
        // Tips if too noisy
        if (_status == _EnvironmentStatus.tooNoisy)
          _buildNoiseTips(),
      ],
    );
  }

  Widget _buildNoiseLevelIndicator() {
    Color indicatorColor;
    IconData icon;
    
    switch (_status) {
      case _EnvironmentStatus.checking:
        indicatorColor = AppTheme.infoColor;
        icon = Icons.mic;
        break;
      case _EnvironmentStatus.good:
        indicatorColor = AppTheme.successColor;
        icon = Icons.check_circle;
        break;
      case _EnvironmentStatus.acceptable:
        indicatorColor = AppTheme.warningColor;
        icon = Icons.warning_amber_rounded;
        break;
      case _EnvironmentStatus.tooNoisy:
        indicatorColor = AppTheme.errorColor;
        icon = Icons.volume_up;
        break;
    }

    return Column(
      children: [
        // Circular indicator with animation
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: indicatorColor.withValues(alpha: 0.1),
              ),
            ),
            
            // Progress ring (only during checking)
            if (_status == _EnvironmentStatus.checking)
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: _checkDuration / _requiredCheckDuration,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
            
            // Icon and level
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: indicatorColor,
                ).animate(
                  onPlay: _status == _EnvironmentStatus.checking
                      ? (c) => c.repeat(reverse: true)
                      : null,
                ).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 500.ms,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_noiseLevel.toStringAsFixed(0)} dB',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: indicatorColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Noise level bar
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (_noiseLevel / 80).clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: indicatorColor,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quiet', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            Text('${_goodThreshold.toInt()} dB', style: TextStyle(color: AppTheme.successColor, fontSize: 12)),
            Text('${_acceptableThreshold.toInt()} dB', style: TextStyle(color: AppTheme.warningColor, fontSize: 12)),
            Text('Loud', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusMessage() {
    String title;
    String message;
    
    switch (_status) {
      case _EnvironmentStatus.checking:
        title = 'Checking Environment...';
        message = 'Please stay quiet while we measure the ambient noise level.';
        break;
      case _EnvironmentStatus.good:
        title = 'Perfect! 🎉';
        message = 'Your environment is quiet enough for an accurate hearing test.';
        break;
      case _EnvironmentStatus.acceptable:
        title = 'Acceptable';
        message = 'The noise level is okay, but finding a quieter space would give more accurate results.';
        break;
      case _EnvironmentStatus.tooNoisy:
        title = 'Too Noisy';
        message = 'The background noise may affect your results. Please try to find a quieter location.';
        break;
    }

    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: TextStyle(
            color: AppTheme.textSecondaryLight,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNoiseTips() {
    final tips = [
      'Close windows and doors',
      'Turn off TVs, radios, or music',
      'Move away from appliances',
      'Ask others nearby to be quiet',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppTheme.warningColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tips to reduce noise:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.check, size: 16, color: AppTheme.warningColor),
                const SizedBox(width: 8),
                Text(tip, style: const TextStyle(color: AppTheme.textPrimaryLight)),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildActionButton() {
    if (_status == _EnvironmentStatus.checking) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (_status == _EnvironmentStatus.tooNoisy)
          OutlinedButton.icon(
            onPressed: _startEnvironmentCheck,
            icon: const Icon(Icons.refresh),
            label: const Text('Check Again'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _proceedToHeadphones,
            style: ElevatedButton.styleFrom(
              backgroundColor: _status == _EnvironmentStatus.good 
                  ? AppTheme.primaryColor 
                  : AppTheme.warningColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _status == _EnvironmentStatus.tooNoisy 
                  ? 'Continue Anyway' 
                  : 'Continue',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _proceedToHeadphones() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScreeningHeadphoneSelectionScreen(
          ambientNoiseDb: _averageNoise,
        ),
      ),
    );
  }
}

enum _EnvironmentStatus {
  checking,
  good,
  acceptable,
  tooNoisy,
}
