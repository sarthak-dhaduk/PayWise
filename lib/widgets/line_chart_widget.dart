import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:paywise/widgets/line_titles.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color.fromARGB(158, 126, 61, 255),
    const Color.fromARGB(255, 126, 61, 255),
  ];

  @override
  Widget build(BuildContext context) => LineChart(
        LineChartData(
          minX: 0,
          maxX: 12,
          minY: 0,
          maxY: 12,
          titlesData: LineTitles.getTitleData(),
          gridData: FlGridData(
            show: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color.fromARGB(255, 255, 255, 255),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: const Color.fromARGB(255, 255, 255, 255),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
            border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255), width: 1),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((lineBarSpot) {
                  return LineTooltipItem(
                    "${lineBarSpot.y} (${lineBarSpot.x})",
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
              getTooltipColor: (spot) => const Color.fromARGB(89, 126, 61, 255).withOpacity(0.75),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isStrokeCapRound: true,
              spots: [
                FlSpot(0, 3),
                FlSpot(2.6, 2),
                FlSpot(4.9, 8),
                FlSpot(6.8, 2.5),
                FlSpot(8, 4),
                FlSpot(9.5, 3),
                FlSpot(12, 12),
              ],
              isCurved: true,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.15))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      );
}
