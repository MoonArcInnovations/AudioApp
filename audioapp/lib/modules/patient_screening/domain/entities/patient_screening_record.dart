class PatientScreeningRecord {
  const PatientScreeningRecord({
    required this.id,
    required this.userId,
    required this.testDate,
    required this.result,
    required this.frequenciesTested,
    required this.thresholds,
    this.headphoneModel,
    this.ambientNoiseDb,
    this.deviceInfo,
  });

  final String id;
  final String userId;
  final DateTime testDate;
  final String? headphoneModel;
  final double? ambientNoiseDb;
  final String result;
  final List<int> frequenciesTested;
  final Map<String, int> thresholds;
  final String? deviceInfo;
}
