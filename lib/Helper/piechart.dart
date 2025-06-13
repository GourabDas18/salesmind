import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartExample extends StatelessWidget {
  const PieChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 0, // No space between sections
        centerSpaceRadius: 0, // Radius of the center space
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
                  color: Colors.blue,  // Progress color
                  value:  60,  // Progress percentage (0 to 100)
                  radius: 100,  // Size of the circle
                  title: '',  // No title for the progress section
                  titleStyle: const TextStyle(fontSize: 0),  // Hide title
                ),
                PieChartSectionData(
                  color: Colors.grey.withOpacity(0.3),  // Background color
                  value: 40,  // Remaining percentage
                  radius: 100,  // Same size as progress circle
                  title: '',  // No title for the remaining section
                  titleStyle: const TextStyle(fontSize: 0),  // Hide title
                ),
      // PieChartSectionData(
      //   value: 40,
      //   title: '40%',
      //   color: Colors.blue,
      //   radius: 100, // Outer radius of the section
      //   titleStyle: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      // ),
      // PieChartSectionData(
      //   value: 30,
      //   title: '30%',
      //   color: Colors.red,
      //   radius: 100,
      //   titleStyle: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      // ),
      // PieChartSectionData(
      //   value: 20,
      //   title: '20%',
      //   color: Colors.green,
      //   radius: 100,
      //   titleStyle: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      // ),
      // PieChartSectionData(
      //   value: 10,
      //   title: '10%',
      //   color: Colors.orange,
      //   radius: 100,
      //   titleStyle: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white,
      //   ),
      // ),
    ];
  }
}