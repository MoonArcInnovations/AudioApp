import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// Data model for a single audiogram threshold point
class AudiogramPoint {
  final int frequency;
  final int thresholdDb;
  final Ear ear;
  final bool noResponse;

  const AudiogramPoint({
    required this.frequency,
    required this.thresholdDb,
    required this.ear,
    this.noResponse = false,
  });
}

/// Widget to display an audiogram chart
class AudiogramChart extends StatelessWidget {
  final List<AudiogramPoint> rightEarData;
  final List<AudiogramPoint> leftEarData;
  final int? highlightedFrequency;
  final Ear? highlightedEar;
  final bool showLegend;
  final double height;

  const AudiogramChart({
    super.key,
    this.rightEarData = const [],
    this.leftEarData = const [],
    this.highlightedFrequency,
    this.highlightedEar,
    this.showLegend = true,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLegend) _buildLegend(context),
        SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 7,
                minY: -10,
                maxY: 120,
                gridData: _buildGridData(),
                titlesData: _buildTitlesData(context),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                lineBarsData: [
                  _buildLineData(rightEarData, AppTheme.rightEarColor, true),
                  _buildLineData(leftEarData, AppTheme.leftEarColor, false),
                ],
                lineTouchData: LineTouchData(enabled: false),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(context, 'Right Ear (O)', AppTheme.rightEarColor),
          const SizedBox(width: 24),
          _buildLegendItem(context, 'Left Ear (X)', AppTheme.leftEarColor),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 10,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        bool isMainLine = value == 0 || value == 25 || value == 55 || value == 90;
        return FlLine(
          color: isMainLine ? Colors.grey.shade400 : Colors.grey.shade200,
          strokeWidth: isMainLine ? 1.5 : 0.5,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey.shade200,
          strokeWidth: 0.5,
        );
      },
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    final frequencies = AppConstants.standardFrequencies;
    
    return FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: RotatedBox(
          quarterTurns: 3,
          child: Text(
            'Hearing Level (dB HL)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        axisNameSize: 30,
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            if (value < 0 || value > 120) return const SizedBox();
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        axisNameWidget: Text(
          'Frequency (Hz)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        axisNameSize: 20,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= frequencies.length) return const SizedBox();
            return Text(
              _formatFrequency(frequencies[index]),
              style: const TextStyle(fontSize: 9),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  String _formatFrequency(int frequency) {
    if (frequency >= 1000) {
      return '${frequency ~/ 1000}k';
    }
    return frequency.toString();
  }

  int _frequencyToIndex(int frequency) {
    final frequencies = AppConstants.standardFrequencies;
    return frequencies.indexOf(frequency);
  }

  LineChartBarData _buildLineData(
    List<AudiogramPoint> points,
    Color color,
    bool isRightEar,
  ) {
    final spots = points.where((p) => !p.noResponse).map((point) {
      final x = _frequencyToIndex(point.frequency).toDouble();
      return FlSpot(x, point.thresholdDb.toDouble());
    }).toList();

    // Sort by x coordinate
    spots.sort((a, b) => a.x.compareTo(b.x));

    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 2,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isHighlighted = highlightedFrequency != null &&
              highlightedEar != null &&
              _frequencyToIndex(highlightedFrequency!) == spot.x.toInt() &&
              ((isRightEar && highlightedEar == Ear.right) ||
                  (!isRightEar && highlightedEar == Ear.left));

          return FlDotCirclePainter(
            radius: isHighlighted ? 8 : 6,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: color,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );
  }
}

/// Classification zones for audiogram
class AudiogramClassification {
  static String getClassification(double pta) {
    if (pta <= 25) return 'Normal';
    if (pta <= 40) return 'Mild';
    if (pta <= 55) return 'Moderate';
    if (pta <= 70) return 'Moderately Severe';
    if (pta <= 90) return 'Severe';
    return 'Profound';
  }

  static Color getClassificationColor(double pta) {
    if (pta <= 25) return AppTheme.successColor;
    if (pta <= 40) return AppTheme.warningColor;
    if (pta <= 55) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
