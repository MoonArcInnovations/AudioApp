import 'dart:convert';
import '../../data/ai/feature_extractor.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';

/// AI inference stub. Replace with real model call later.
class AiInferenceService {
  final FeatureExtractor _extractor = FeatureExtractor();

  /// Returns a placeholder suggestion based on simple rules.
  Map<String, dynamic> analyze({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) {
    final features = _extractor.extract(ac: ac, bc: bc);
    final airBoneGap = features['airBoneGapMaxDb'] as num? ?? 0;

    String type;
    if (airBoneGap >= 15) {
      type = 'conductive';
    } else {
      type = 'sensorineural';
    }

    return {
      'type': type,
      'confidence': 0.55,
      'features': features,
      'notes': 'Stub inference. Replace with real model.',
    };
  }

  String analyzeAsJson({
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
  }) {
    return jsonEncode(analyze(ac: ac, bc: bc));
  }
}
