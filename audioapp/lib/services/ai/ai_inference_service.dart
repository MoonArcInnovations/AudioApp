import 'dart:convert';
import '../../data/ai/feature_extractor.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';

/// AI inference stub. Replace with real model call later.
class AiInferenceService {
  final FeatureExtractor _extractor = FeatureExtractor();

  /// Returns an explainable rules-based interpretation for AC + BC tests.
  Map<String, dynamic> analyze({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) {
    final features = _extractor.extract(ac: ac, bc: bc);
    final right = _classifyEar(
      earLabel: 'Right ear',
      acPta: ac.rightPta,
      bcPta: features['boneRightPta'] as double? ?? 0,
      gapByFrequency: _mapIntInt(features['airBoneGapRight']),
    );
    final left = _classifyEar(
      earLabel: 'Left ear',
      acPta: ac.leftPta,
      bcPta: features['boneLeftPta'] as double? ?? 0,
      gapByFrequency: _mapIntInt(features['airBoneGapLeft']),
    );

    final warnings = List<String>.from(
      features['qualityWarnings'] as List? ?? const [],
    );
    if (right.warning != null) warnings.add(right.warning!);
    if (left.warning != null) warnings.add(left.warning!);

    final type = _overallType(right.type, left.type);
    final confidence = _confidence(
      right: right,
      left: left,
      warnings: warnings,
      overlapFrequencyCount: features['overlapFrequencyCount'] as int? ?? 0,
    );

    return {
      'type': type,
      'confidence': confidence,
      'modelVersion': 'rules-0.2',
      'features': features,
      'severity': {
        'right': _severity(ac.rightPta),
        'left': _severity(ac.leftPta),
      },
      'rationale': [
        ...right.rationale,
        ...left.rationale,
        'Overall suggestion combines right and left ear AC/BC patterns.',
      ],
      'warnings': warnings,
      'notes':
          'Rules-based assistive interpretation. Clinician verification required.',
    };
  }

  String analyzeAsJson({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) {
    return jsonEncode(analyze(ac: ac, bc: bc));
  }

  _EarInterpretation _classifyEar({
    required String earLabel,
    required double acPta,
    required double bcPta,
    required Map<int, int> gapByFrequency,
  }) {
    final clinicallySignificantGaps = gapByFrequency.entries
        .where((entry) => entry.value >= 15)
        .toList();
    final maxGap = gapByFrequency.values.isEmpty
        ? 0
        : gapByFrequency.values.reduce((a, b) => a > b ? a : b);
    final acElevated = acPta > 25;
    final bcElevated = bcPta > 25;

    if (gapByFrequency.isEmpty) {
      return _EarInterpretation(
        type: acElevated ? 'insufficient_data' : 'normal',
        rationale: [
          '$earLabel has no overlapping AC/BC frequencies for gap analysis.',
        ],
        warning: '$earLabel needs overlapping AC and BC thresholds.',
      );
    }

    if (!acElevated && !bcElevated && maxGap < 15) {
      return _EarInterpretation(
        type: 'normal',
        rationale: [
          '$earLabel PTA is within normal range and no significant air-bone gap was found.',
        ],
      );
    }

    if (clinicallySignificantGaps.isNotEmpty && !bcElevated) {
      return _EarInterpretation(
        type: 'conductive',
        rationale: [
          '$earLabel has air-bone gap >= 15 dB at ${_frequencyList(clinicallySignificantGaps)}.',
          '$earLabel bone PTA is ${bcPta.toStringAsFixed(1)} dB HL.',
        ],
      );
    }

    if (clinicallySignificantGaps.isNotEmpty && bcElevated) {
      return _EarInterpretation(
        type: 'mixed',
        rationale: [
          '$earLabel has elevated bone PTA (${bcPta.toStringAsFixed(1)} dB HL) plus air-bone gap >= 15 dB.',
        ],
      );
    }

    if (acElevated && maxGap < 15) {
      return _EarInterpretation(
        type: 'sensorineural',
        rationale: [
          '$earLabel AC PTA is elevated (${acPta.toStringAsFixed(1)} dB HL) without a significant air-bone gap.',
        ],
      );
    }

    return _EarInterpretation(
      type: 'insufficient_data',
      rationale: [
        '$earLabel pattern is not specific enough for classification.',
      ],
      warning:
          '$earLabel requires clinician review due to ambiguous AC/BC pattern.',
    );
  }

  Map<int, int> _mapIntInt(Object? value) {
    if (value is Map<int, int>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(
          key is int ? key : int.parse(key.toString()),
          item is int ? item : (item as num).round(),
        ),
      );
    }
    return const {};
  }

  String _overallType(String right, String left) {
    final types = {right, left}..remove('normal');
    if (types.isEmpty) {
      return 'normal';
    }
    if (types.contains('insufficient_data')) {
      return 'insufficient_data';
    }
    if (types.length == 1) {
      return types.first;
    }
    if (types.contains('mixed')) {
      return 'mixed';
    }
    return 'mixed';
  }

  double _confidence({
    required _EarInterpretation right,
    required _EarInterpretation left,
    required List<String> warnings,
    required int overlapFrequencyCount,
  }) {
    var score = 0.78;
    if (overlapFrequencyCount >= 6) {
      score += 0.08;
    } else if (overlapFrequencyCount < 4) {
      score -= 0.12;
    }
    score -= warnings.length * 0.06;
    if (right.type == 'insufficient_data' || left.type == 'insufficient_data') {
      score -= 0.18;
    }
    return score.clamp(0.30, 0.92);
  }

  String _severity(double pta) {
    if (pta <= 25) return 'normal';
    if (pta <= 40) return 'mild';
    if (pta <= 55) return 'moderate';
    if (pta <= 70) return 'moderately_severe';
    if (pta <= 90) return 'severe';
    return 'profound';
  }

  String _frequencyList(List<MapEntry<int, int>> entries) {
    return entries
        .map((entry) => '${entry.key} Hz (${entry.value} dB)')
        .join(', ');
  }
}

class _EarInterpretation {
  const _EarInterpretation({
    required this.type,
    required this.rationale,
    this.warning,
  });

  final String type;
  final List<String> rationale;
  final String? warning;
}
