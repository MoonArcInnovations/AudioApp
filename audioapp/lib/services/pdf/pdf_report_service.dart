import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/ai_review/domain/entities/ai_recommendation_record.dart';
import '../../modules/clinician_testing/domain/entities/clinician_patient_record.dart';
import '../../modules/clinician_testing/domain/entities/clinician_test_record.dart';
import '../../shared/widgets/audiogram_chart.dart';

final pdfReportServiceProvider = Provider<PdfReportService>(
  (ref) => PdfReportService(),
);

/// Service for generating PDF audiometry reports
class PdfReportService {
  static final PdfReportService _instance = PdfReportService._internal();
  factory PdfReportService() => _instance;
  PdfReportService._internal();
  static final PdfColor rightEarPdf = PdfColor.fromInt(0xFFC4523C);
  static final PdfColor leftEarPdf = PdfColor.fromInt(0xFF6E7A3A);
  static final PdfColor primaryPdf = PdfColor.fromInt(0xFFB35C3A);
  static final PdfColor accentPdf = PdfColor.fromInt(0xFFD29A4B);

  /// Generate a report from a TestResult and Patient
  Future<Uint8List> generateTestReport(
    ClinicianTestRecord test,
    ClinicianPatientRecord patient,
  ) async {
    return generateReport(
      patientName: patient.name,
      patientDob: DateFormat('MMMM d, yyyy').format(patient.dateOfBirth),
      patientId: patient.id,
      audiologistName: test.audiologistId,
      testDate: test.testDate,
      rightEarResults: test.rightEarResults,
      leftEarResults: test.leftEarResults,
      notes: test.notes,
      recommendations: test.recommendations,
    );
  }

  /// Generate combined AC+BC report with AI decision
  Future<Uint8List> generateCombinedReport({
    required ClinicianPatientRecord patient,
    required ClinicianTestRecord ac,
    required ClinicianTestRecord bc,
    AiRecommendationRecord? ai,
    List<AiRecommendationRecord> aiHistory = const [],
  }) async {
    final pdf = pw.Document();

    final rightPta = _calculatePta(ac.rightEarResults);
    final leftPta = _calculatePta(ac.leftEarResults);
    final rightClass = AudiogramClassification.getClassification(rightPta);
    final leftClass = AudiogramClassification.getClassification(leftPta);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooterWithAiHistory(context, aiHistory),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'COMBINED AC + BC REPORT',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          _buildSectionTitle('Patient Information'),
          _buildInfoRow('Name:', patient.name),
          _buildInfoRow(
            'Date of Birth:',
            DateFormat('MMMM d, yyyy').format(patient.dateOfBirth),
          ),
          _buildInfoRow('Patient ID:', patient.id),
          _buildInfoRow(
            'AC Test Date:',
            DateFormat('MMMM d, yyyy').format(ac.testDate),
          ),
          _buildInfoRow(
            'BC Test Date:',
            DateFormat('MMMM d, yyyy').format(bc.testDate),
          ),
          pw.SizedBox(height: 20),

          _buildSectionTitle('Audiogram (Air Conduction)'),
          _buildAudiogramTable(ac.rightEarResults, ac.leftEarResults),
          pw.SizedBox(height: 10),
          _buildAudiogramLegend(),
          pw.SizedBox(height: 20),

          _buildSectionTitle('Results Summary'),
          pw.Row(
            children: [
              pw.Expanded(
                child: _buildPtaBox(
                  'Right Ear (AC)',
                  rightPta,
                  rightClass,
                  rightEarPdf,
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: _buildPtaBox(
                  'Left Ear (AC)',
                  leftPta,
                  leftClass,
                  leftEarPdf,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          _buildSectionTitle('Air Conduction Thresholds (dB HL)'),
          _buildThresholdTable(ac.rightEarResults, ac.leftEarResults),
          pw.SizedBox(height: 20),

          _buildSectionTitle('Bone Conduction Thresholds (dB HL)'),
          _buildThresholdTable(bc.rightEarResults, bc.leftEarResults),
          pw.SizedBox(height: 20),

          _buildSectionTitle('Air-Bone Gap (dB)'),
          _buildAirBoneGapTable(ac, bc),
          pw.SizedBox(height: 20),

          if (ai != null) ...[
            _buildSectionTitle('AI Assist Summary'),
            _buildAiSection(ai),
            pw.SizedBox(height: 20),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate a complete audiometry report PDF
  Future<Uint8List> generateReport({
    required String patientName,
    required String patientDob,
    required String patientId,
    required String audiologistName,
    required DateTime testDate,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    String? notes,
    String? recommendations,
  }) async {
    final pdf = pw.Document();

    // Calculate PTAs
    final rightPta = _calculatePta(rightEarResults);
    final leftPta = _calculatePta(leftEarResults);
    final rightClass = AudiogramClassification.getClassification(rightPta);
    final leftClass = AudiogramClassification.getClassification(leftPta);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          // Title
          pw.Center(
            child: pw.Text(
              'AUDIOMETRY TEST REPORT',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          // Patient Information
          _buildSectionTitle('Patient Information'),
          _buildInfoRow('Name:', patientName),
          _buildInfoRow('Date of Birth:', patientDob),
          _buildInfoRow('Patient ID:', patientId),
          _buildInfoRow(
            'Test Date:',
            DateFormat('MMMM d, yyyy \'at\' h:mm a').format(testDate),
          ),
          _buildInfoRow('Audiologist:', audiologistName),
          pw.SizedBox(height: 20),

          // Audiogram
          _buildSectionTitle('Audiogram'),
          _buildAudiogramTable(rightEarResults, leftEarResults),
          pw.SizedBox(height: 10),
          _buildAudiogramLegend(),
          pw.SizedBox(height: 20),

          // Results Summary
          _buildSectionTitle('Results Summary'),
          pw.Row(
            children: [
              pw.Expanded(
                child: _buildPtaBox(
                  'Right Ear',
                  rightPta,
                  rightClass,
                  rightEarPdf,
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: _buildPtaBox('Left Ear', leftPta, leftClass, leftEarPdf),
              ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Threshold Values Table
          _buildSectionTitle('Threshold Values (dB HL)'),
          _buildThresholdTable(rightEarResults, leftEarResults),
          pw.SizedBox(height: 20),

          // Classification Guide
          _buildSectionTitle('Hearing Loss Classification'),
          _buildClassificationGuide(),
          pw.SizedBox(height: 20),

          // Notes and Recommendations
          if (notes != null && notes.isNotEmpty) ...[
            _buildSectionTitle('Clinical Notes'),
            pw.Text(notes),
            pw.SizedBox(height: 20),
          ],

          if (recommendations != null && recommendations.isNotEmpty) ...[
            _buildSectionTitle('Recommendations'),
            pw.Text(recommendations),
            pw.SizedBox(height: 20),
          ],

          // Signature
          pw.SizedBox(height: 40),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 150,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    height: 30,
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('Audiologist Signature'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 100,
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide()),
                    ),
                    height: 30,
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('Date'),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'AudioApp',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: primaryPdf,
            ),
          ),
          pw.Text(
            'Professional Audiometry',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'This report is for professional use only.',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: primaryPdf,
        ),
      ),
    );
  }

  pw.Widget _buildAiSection(AiRecommendationRecord ai) {
    final decision = ai.accepted == null
        ? 'Pending'
        : (ai.accepted! ? 'Accepted' : 'Overridden');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Suggestion:', ai.suggestionType),
        _buildInfoRow(
          'Confidence:',
          '${(ai.confidence * 100).toStringAsFixed(0)}%',
        ),
        _buildInfoRow('Decision:', decision),
        if (ai.decisionNotes != null && ai.decisionNotes!.isNotEmpty)
          _buildInfoRow('Notes:', ai.decisionNotes!),
        if (ai.rationale.isNotEmpty) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            'Rationale:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          ...ai.rationale.take(3).map((item) => pw.Text('- $item')),
        ],
        if (ai.warnings.isNotEmpty) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            'Warnings:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          ...ai.warnings.take(3).map((item) => pw.Text('- $item')),
        ],
      ],
    );
  }

  pw.Widget _buildAirBoneGapTable(
    ClinicianTestRecord ac,
    ClinicianTestRecord bc,
  ) {
    final freqs = AppConstants.standardFrequencies;
    final acRight = {
      for (final p in ac.rightEarResults) p.frequency: p.thresholdDb,
    };
    final acLeft = {
      for (final p in ac.leftEarResults) p.frequency: p.thresholdDb,
    };
    final bcRight = {
      for (final p in bc.rightEarResults) p.frequency: p.thresholdDb,
    };
    final bcLeft = {
      for (final p in bc.leftEarResults) p.frequency: p.thresholdDb,
    };

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {0: const pw.FlexColumnWidth(1.5)},
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableCell('Ear', isHeader: true),
            ...freqs.map(
              (f) => _tableCell(
                f >= 1000 ? '${f ~/ 1000}k' : f.toString(),
                isHeader: true,
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            _tableCell('Right', isHeader: true, color: rightEarPdf),
            ...freqs.map((f) {
              if (!acRight.containsKey(f) || !bcRight.containsKey(f)) {
                return _tableCell('-');
              }
              return _tableCell((acRight[f]! - bcRight[f]!).toString());
            }),
          ],
        ),
        pw.TableRow(
          children: [
            _tableCell('Left', isHeader: true, color: leftEarPdf),
            ...freqs.map((f) {
              if (!acLeft.containsKey(f) || !bcLeft.containsKey(f)) {
                return _tableCell('-');
              }
              return _tableCell((acLeft[f]! - bcLeft[f]!).toString());
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooterWithAiHistory(
    pw.Context context,
    List<AiRecommendationRecord> history,
  ) {
    final base = _buildFooter(context);
    if (history.isEmpty) return base;
    final recent = history.take(3).toList();
    final items = recent
        .map((r) {
          final decision = r.accepted == null
              ? 'Pending'
              : (r.accepted! ? 'Accepted' : 'Overridden');
          return 'AI ${r.suggestionType} ${r.confidence.toStringAsFixed(2)} $decision';
        })
        .join(' | ');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        base,
        pw.SizedBox(height: 6),
        pw.Text(
          'AI Decision History: $items',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(value),
        ],
      ),
    );
  }

  pw.Widget _buildAudiogramTable(
    List<AudiogramPoint> rightEar,
    List<AudiogramPoint> leftEar,
  ) {
    final frequencies = AppConstants.standardFrequencies;

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableCell('Frequency (Hz)', isHeader: true),
            ...frequencies.map(
              (f) => _tableCell(
                f >= 1000 ? '${f ~/ 1000}k' : f.toString(),
                isHeader: true,
              ),
            ),
          ],
        ),
        // Right ear
        pw.TableRow(
          children: [
            _tableCell('Right Ear', isHeader: true, color: rightEarPdf),
            ...frequencies.map((f) {
              final point = rightEar.firstWhere(
                (p) => p.frequency == f,
                orElse: () => AudiogramPoint(
                  frequency: f,
                  thresholdDb: -1,
                  ear: Ear.right,
                ),
              );
              return _tableCell(
                point.thresholdDb >= 0
                    ? point.noResponse
                          ? 'NR'
                          : point.thresholdDb.toString()
                    : '-',
              );
            }),
          ],
        ),
        // Left ear
        pw.TableRow(
          children: [
            _tableCell('Left Ear', isHeader: true, color: leftEarPdf),
            ...frequencies.map((f) {
              final point = leftEar.firstWhere(
                (p) => p.frequency == f,
                orElse: () => AudiogramPoint(
                  frequency: f,
                  thresholdDb: -1,
                  ear: Ear.left,
                ),
              );
              return _tableCell(
                point.thresholdDb >= 0
                    ? point.noResponse
                          ? 'NR'
                          : point.thresholdDb.toString()
                    : '-',
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _tableCell(String text, {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : null,
          fontSize: 10,
          color: color,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildAudiogramLegend() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        _legendItem('Right Ear (O)', rightEarPdf),
        pw.SizedBox(width: 30),
        _legendItem('Left Ear (X)', leftEarPdf),
        pw.SizedBox(width: 30),
        _legendItem('NR = No Response', PdfColors.grey600),
      ],
    );
  }

  pw.Widget _legendItem(String text, PdfColor color) {
    return pw.Row(
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
        ),
        pw.SizedBox(width: 4),
        pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  pw.Widget _buildPtaBox(
    String title,
    double pta,
    String classification,
    PdfColor color,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: color),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            '${pta.toStringAsFixed(1)} dB HL',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: pw.BoxDecoration(
              color: _getClassColor(pta),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              classification,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
            ),
          ),
        ],
      ),
    );
  }

  PdfColor _getClassColor(double pta) {
    if (pta <= 25) return PdfColor.fromInt(0xFF2F7D5B);
    if (pta <= 40) return PdfColor.fromInt(0xFFD08B2C);
    if (pta <= 55) return PdfColor.fromInt(0xFFD08B2C);
    return PdfColor.fromInt(0xFFC83B2D);
  }

  pw.Widget _buildThresholdTable(
    List<AudiogramPoint> rightEar,
    List<AudiogramPoint> leftEar,
  ) {
    final frequencies = AppConstants.standardFrequencies;

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {0: const pw.FlexColumnWidth(1.5)},
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableCell('Ear', isHeader: true),
            ...frequencies.map(
              (f) => _tableCell(
                f >= 1000 ? '${f ~/ 1000}k' : f.toString(),
                isHeader: true,
              ),
            ),
            _tableCell('PTA', isHeader: true),
          ],
        ),
        pw.TableRow(
          children: [
            _tableCell('Right', isHeader: true, color: rightEarPdf),
            ...frequencies.map((f) {
              final point = rightEar.firstWhere(
                (p) => p.frequency == f,
                orElse: () => AudiogramPoint(
                  frequency: f,
                  thresholdDb: -1,
                  ear: Ear.right,
                ),
              );
              return _tableCell(
                point.thresholdDb >= 0 ? point.thresholdDb.toString() : '-',
              );
            }),
            _tableCell(_calculatePta(rightEar).toStringAsFixed(1)),
          ],
        ),
        pw.TableRow(
          children: [
            _tableCell('Left', isHeader: true, color: leftEarPdf),
            ...frequencies.map((f) {
              final point = leftEar.firstWhere(
                (p) => p.frequency == f,
                orElse: () => AudiogramPoint(
                  frequency: f,
                  thresholdDb: -1,
                  ear: Ear.left,
                ),
              );
              return _tableCell(
                point.thresholdDb >= 0 ? point.thresholdDb.toString() : '-',
              );
            }),
            _tableCell(_calculatePta(leftEar).toStringAsFixed(1)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildClassificationGuide() {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _tableCell('Classification', isHeader: true),
            _tableCell('PTA Range (dB HL)', isHeader: true),
          ],
        ),
        _classRow('Normal', '0 - 25', PdfColor.fromInt(0xFF2F7D5B)),
        _classRow('Mild Loss', '26 - 40', PdfColor.fromInt(0xFFD08B2C)),
        _classRow('Moderate Loss', '41 - 55', PdfColor.fromInt(0xFFD08B2C)),
        _classRow('Moderately Severe', '56 - 70', PdfColor.fromInt(0xFFC83B2D)),
        _classRow('Severe Loss', '71 - 90', PdfColor.fromInt(0xFF8B241D)),
        _classRow('Profound Loss', '91+', PdfColor.fromInt(0xFF6F1B16)),
      ],
    );
  }

  pw.TableRow _classRow(String name, String range, PdfColor color) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Row(
            children: [
              pw.Container(
                width: 10,
                height: 10,
                decoration: pw.BoxDecoration(color: color),
              ),
              pw.SizedBox(width: 8),
              pw.Text(name, style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
        _tableCell(range),
      ],
    );
  }

  double _calculatePta(List<AudiogramPoint> results) {
    final ptaFrequencies = [500, 1000, 2000, 4000];
    final ptaValues = <int>[];

    for (final freq in ptaFrequencies) {
      final point = results.firstWhere(
        (p) => p.frequency == freq && !p.noResponse,
        orElse: () =>
            AudiogramPoint(frequency: 0, thresholdDb: -1, ear: Ear.right),
      );
      if (point.thresholdDb >= 0) {
        ptaValues.add(point.thresholdDb);
      }
    }

    if (ptaValues.isEmpty) return 0;
    return ptaValues.reduce((a, b) => a + b) / ptaValues.length;
  }

  /// Preview the PDF report
  Future<void> previewReport({
    required String patientName,
    required String patientDob,
    required String patientId,
    required String audiologistName,
    required DateTime testDate,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    String? notes,
    String? recommendations,
  }) async {
    final pdfData = await generateReport(
      patientName: patientName,
      patientDob: patientDob,
      patientId: patientId,
      audiologistName: audiologistName,
      testDate: testDate,
      rightEarResults: rightEarResults,
      leftEarResults: leftEarResults,
      notes: notes,
      recommendations: recommendations,
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfData,
      name: 'Audiometry_Report_${patientName.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Share the PDF report
  Future<void> shareReport({
    required String patientName,
    required String patientDob,
    required String patientId,
    required String audiologistName,
    required DateTime testDate,
    required List<AudiogramPoint> rightEarResults,
    required List<AudiogramPoint> leftEarResults,
    String? notes,
    String? recommendations,
  }) async {
    final pdfData = await generateReport(
      patientName: patientName,
      patientDob: patientDob,
      patientId: patientId,
      audiologistName: audiologistName,
      testDate: testDate,
      rightEarResults: rightEarResults,
      leftEarResults: leftEarResults,
      notes: notes,
      recommendations: recommendations,
    );

    await Printing.sharePdf(
      bytes: pdfData,
      filename: 'Audiometry_Report_${patientName.replaceAll(' ', '_')}.pdf',
    );
  }
}
