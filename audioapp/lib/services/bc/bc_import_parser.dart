import 'dart:io';
import 'package:xml/xml.dart';
import '../../core/constants/app_constants.dart';

class ParsedBcResult {
  final Map<int, int> rightEar;
  final Map<int, int> leftEar;
  final DateTime testDate;
  final String? notes;

  ParsedBcResult({
    required this.rightEar,
    required this.leftEar,
    required this.testDate,
    this.notes,
  });

  bool get hasData => rightEar.isNotEmpty || leftEar.isNotEmpty;
}

class BcImportParser {
  Future<ParsedBcResult> parse(File file, String fileType) async {
    final content = await file.readAsString();
    switch (fileType.toLowerCase()) {
      case 'xml':
        return _parseXml(content);
      case 'hl7':
        return _parseHl7(content);
      default:
        return ParsedBcResult(
          rightEar: {},
          leftEar: {},
          testDate: DateTime.now(),
        );
    }
  }

  ParsedBcResult _parseXml(String xmlString) {
    final right = <int, int>{};
    final left = <int, int>{};
    final doc = XmlDocument.parse(xmlString);

    for (final node in doc.descendants.whereType<XmlElement>()) {
      final name = node.name.local.toLowerCase();
      if (name != 'threshold' && name != 'point' && name != 'result') continue;

      final freq = _readIntAttr(node, ['frequency', 'freq', 'hz']);
      final db = _readIntAttr(node, ['db', 'threshold', 'value']);
      if (freq == null || db == null) continue;

      final ear = _inferEar(node);
      if (ear == Ear.right) {
        right[freq] = db;
      } else if (ear == Ear.left) {
        left[freq] = db;
      }
    }

    return ParsedBcResult(
      rightEar: right,
      leftEar: left,
      testDate: DateTime.now(),
      notes: right.isEmpty && left.isEmpty
          ? 'No threshold nodes matched expected format.'
          : null,
    );
  }

  ParsedBcResult _parseHl7(String hl7) {
    final right = <int, int>{};
    final left = <int, int>{};

    final lines = hl7
        .split(RegExp(r'[\r\n]+'))
        .where((l) => l.trim().isNotEmpty);
    for (final line in lines) {
      if (!line.startsWith('OBX|')) continue;
      final fields = line.split('|');
      if (fields.length < 6) continue;

      final obxId = fields[3];
      final obxValue = fields[5];
      final freq = _extractFrequency(obxId) ?? _extractFrequency(obxValue);
      final db = int.tryParse(obxValue.replaceAll(RegExp(r'[^0-9-]'), ''));
      if (freq == null || db == null) continue;

      final ear =
          _inferEarFromText(obxId) ?? _inferEarFromText(fields.join('|'));
      if (ear == Ear.right) {
        right[freq] = db;
      } else if (ear == Ear.left) {
        left[freq] = db;
      }
    }

    return ParsedBcResult(
      rightEar: right,
      leftEar: left,
      testDate: DateTime.now(),
      notes: right.isEmpty && left.isEmpty
          ? 'No OBX segments matched expected frequency/threshold format.'
          : null,
    );
  }

  int? _readIntAttr(XmlElement node, List<String> keys) {
    for (final key in keys) {
      final value = node.getAttribute(key);
      if (value == null) continue;
      final parsed = int.tryParse(value.replaceAll(RegExp(r'[^0-9-]'), ''));
      if (parsed != null) return parsed;
    }
    return null;
  }

  int? _extractFrequency(String text) {
    final match = RegExp(r'(\d{2,5})').firstMatch(text);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  Ear? _inferEar(XmlElement node) {
    XmlElement? current = node;
    while (current != null) {
      final name = current.name.local.toLowerCase();
      if (name.contains('right')) return Ear.right;
      if (name.contains('left')) return Ear.left;

      final side = current.getAttribute('side') ?? current.getAttribute('ear');
      if (side != null) {
        final s = side.toLowerCase();
        if (s.startsWith('r')) return Ear.right;
        if (s.startsWith('l')) return Ear.left;
      }
      current = current.parent is XmlElement
          ? current.parent as XmlElement
          : null;
    }
    return null;
  }

  Ear? _inferEarFromText(String text) {
    final upper = text.toUpperCase();
    if (upper.contains('RIGHT') || upper.contains(' R ')) return Ear.right;
    if (upper.contains('LEFT') || upper.contains(' L ')) return Ear.left;
    if (upper.contains('EAR:R') || upper.contains('EAR=R')) return Ear.right;
    if (upper.contains('EAR:L') || upper.contains('EAR=L')) return Ear.left;
    return null;
  }
}
