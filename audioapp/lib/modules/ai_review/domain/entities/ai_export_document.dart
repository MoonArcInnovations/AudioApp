class AiExportDocument {
  const AiExportDocument({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    this.shareText,
  });

  final List<int> bytes;
  final String fileName;
  final String mimeType;
  final String? shareText;
}
