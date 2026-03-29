import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import 'screening_test_screen.dart';

/// Headphone selection screen for screening
class ScreeningHeadphoneSelectionScreen extends ConsumerStatefulWidget {
  final double ambientNoiseDb;
  
  const ScreeningHeadphoneSelectionScreen({
    super.key,
    required this.ambientNoiseDb,
  });

  @override
  ConsumerState<ScreeningHeadphoneSelectionScreen> createState() => _ScreeningHeadphoneSelectionScreenState();
}

class _ScreeningHeadphoneSelectionScreenState extends ConsumerState<ScreeningHeadphoneSelectionScreen> {
  _HeadphoneOption? _selectedHeadphone;
  bool _isVerifying = false;
  bool _isVerified = false;

  final List<_HeadphoneOption> _headphoneOptions = [
    _HeadphoneOption(
      id: 'airpods_pro',
      name: 'AirPods Pro',
      brand: 'Apple',
      icon: Icons.headphones,
      type: _HeadphoneType.trulyWireless,
      isRecommended: true,
    ),
    _HeadphoneOption(
      id: 'airpods',
      name: 'AirPods (Regular)',
      brand: 'Apple',
      icon: Icons.headphones,
      type: _HeadphoneType.trulyWireless,
    ),
    _HeadphoneOption(
      id: 'galaxy_buds',
      name: 'Galaxy Buds',
      brand: 'Samsung',
      icon: Icons.headphones,
      type: _HeadphoneType.trulyWireless,
    ),
    _HeadphoneOption(
      id: 'earpods',
      name: 'EarPods (Wired)',
      brand: 'Apple',
      icon: Icons.headset,
      type: _HeadphoneType.wired,
    ),
    _HeadphoneOption(
      id: 'wired_earbuds',
      name: 'Other Wired Earbuds',
      brand: 'Generic',
      icon: Icons.headset,
      type: _HeadphoneType.wired,
    ),
    _HeadphoneOption(
      id: 'over_ear',
      name: 'Over-Ear Headphones',
      brand: 'Any',
      icon: Icons.headset_mic,
      type: _HeadphoneType.overEar,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Headphones'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.headphones,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Which headphones are you using?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your headphones for optimal calibration',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Headphone options
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _headphoneOptions.length,
                itemBuilder: (context, index) {
                  final option = _headphoneOptions[index];
                  final isSelected = _selectedHeadphone?.id == option.id;
                  
                  return _buildHeadphoneCard(option, isSelected);
                },
              ),
            ),
            
            // Verification status and continue button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadphoneCard(_HeadphoneOption option, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected 
            ? AppTheme.primaryColor.withValues(alpha: 0.1) 
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedHeadphone = option;
              _isVerified = false;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryColor.withValues(alpha: 0.2)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    option.icon,
                    size: 28,
                    color: isSelected ? AppTheme.primaryColor : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            option.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppTheme.primaryColor : null,
                            ),
                          ),
                          if (option.isRecommended) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Recommended',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.successColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${option.brand} • ${option.type.displayName}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (50 * _headphoneOptions.indexOf(option)).ms);
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Verification status
          if (_selectedHeadphone != null && !_isVerified)
            _buildVerificationSection(),
          
          if (_isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.successColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.successColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Headphones verified and calibrated!',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
          
          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedHeadphone != null && _isVerified
                  ? _startTest
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Start Hearing Test',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.infoColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up, color: AppTheme.infoColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Let\'s verify your headphones',
                  style: TextStyle(
                    color: AppTheme.infoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tap the button below and confirm you hear a beep in both ears.',
            style: TextStyle(
              color: AppTheme.textSecondaryLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isVerifying ? null : _playTestTone,
                  icon: _isVerifying 
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation(AppTheme.infoColor),
                          ),
                        )
                      : const Icon(Icons.play_arrow, color: AppTheme.infoColor),
                  label: Text(
                    _isVerifying ? 'Playing...' : 'Play Test Tone',
                    style: const TextStyle(color: AppTheme.infoColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.infoColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isVerifying ? null : _confirmHeadphones,
                  icon: const Icon(Icons.check),
                  label: const Text('I Heard It'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.infoColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _playTestTone() async {
    setState(() {
      _isVerifying = true;
    });
    
    // Simulate playing a test tone
    // In production, use the AudioService to play a 1kHz tone
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isVerifying = false;
    });
  }

  void _confirmHeadphones() {
    setState(() {
      _isVerified = true;
    });
  }

  void _startTest() {
    if (_selectedHeadphone == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScreeningTestScreen(
          headphoneModel: _selectedHeadphone!.name,
          ambientNoiseDb: widget.ambientNoiseDb,
        ),
      ),
    );
  }
}

class _HeadphoneOption {
  final String id;
  final String name;
  final String brand;
  final IconData icon;
  final _HeadphoneType type;
  final bool isRecommended;

  const _HeadphoneOption({
    required this.id,
    required this.name,
    required this.brand,
    required this.icon,
    required this.type,
    this.isRecommended = false,
  });
}

enum _HeadphoneType {
  trulyWireless('Truly Wireless'),
  wired('Wired'),
  overEar('Over-Ear');

  const _HeadphoneType(this.displayName);
  final String displayName;
}
