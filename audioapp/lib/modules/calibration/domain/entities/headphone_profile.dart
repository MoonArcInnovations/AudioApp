enum HeadphoneProfileType {
  tdh39,
  er3a,
  hda300,
  airpodsPro2,
  galaxyBudsPro,
  airpods3,
  earpods,
  generic,
}

enum CalibrationAccuracy { clinical, validated, screening, approximate }

enum ApprovedUse { diagnostic, screening, screeningOnly, screeningWithWarning }

class HeadphoneProfileDetails {
  const HeadphoneProfileDetails({
    required this.profileType,
    required this.name,
    required this.brand,
    required this.type,
    required this.accuracy,
    required this.accuracyDb,
    required this.isValidated,
    required this.approvedUse,
    required this.description,
  });

  final HeadphoneProfileType profileType;
  final String name;
  final String brand;
  final String type;
  final CalibrationAccuracy accuracy;
  final int accuracyDb;
  final bool isValidated;
  final ApprovedUse approvedUse;
  final String description;
}
