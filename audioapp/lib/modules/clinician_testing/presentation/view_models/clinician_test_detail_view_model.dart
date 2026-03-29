import 'clinician_test_summary_view_model.dart';

class ClinicianTestDetailViewModel {
  const ClinicianTestDetailViewModel({
    required this.test,
    required this.relatedTest,
    required this.rightAirBoneGap,
    required this.leftAirBoneGap,
  });

  final ClinicianTestSummaryViewModel test;
  final ClinicianTestSummaryViewModel? relatedTest;
  final Map<int, int> rightAirBoneGap;
  final Map<int, int> leftAirBoneGap;
}
