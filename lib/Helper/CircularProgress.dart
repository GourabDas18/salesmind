
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double fillValue;
  final double emptyValue;
  final Color fillColor;
  final Color emptyColor;
  final String? fillText;
  final String? emptyText;
  final double? height;
  final double? widget;
  const CircularProgress({super.key, required this.fillValue, required this.emptyValue, required this.fillColor, required this.emptyColor, this.fillText, this.emptyText, this.height, this.widget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  height ?? 200,
      width: widget ?? 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0, // No space between sections
          centerSpaceRadius: 0, // Radius of the center space
          sections: [
            PieChartSectionData(
                    color: fillColor,  // Progress color
                    value:  fillValue,  // Progress percentage (0 to 100)
                    radius: 100,  // Size of the circle
                    title: fillText,  // No title for the progress section
                    titleStyle: const TextStyle(fontSize: 10),
            ),
            PieChartSectionData(
                    color: emptyColor,  // Progress color
                    value:  emptyValue,  // Progress percentage (0 to 100)
                    radius: 100,  // Size of the circle
                    title: emptyText,  // No title for the progress section
                    titleStyle: const TextStyle(fontSize: 10),
            )
          ]
        ),
      ),
    );
  }
}