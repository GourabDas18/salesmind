
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartHelper extends StatelessWidget {

  final List<BarChartGroupData> barGroups;
  final Widget Function(double, TitleMeta)? getTitlesWidget;
  const BarChartHelper({super.key,this.getTitlesWidget,required this.barGroups});

  @override
  Widget build(BuildContext context) {
    return BarChart(

                BarChartData(
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                      direction: TooltipDirection.auto,
                      fitInsideVertically: true,
                      getTooltipColor: (group) => Colors.white,
                      fitInsideHorizontally: true,
                      
                    )),
                    backgroundColor: const Color.fromARGB(255, 17, 17, 17),
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: const AxisTitles(
                          axisNameSize: 40,
                          drawBelowEverything: true,
                          sideTitles: SideTitles(
                              reservedSize: 50,
                              showTitles: true,
                              maxIncluded: true,
                              minIncluded: true)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getTitlesWidget ?? (value,meta)=>Text(value.toString())
                      )),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: const Border(bottom: BorderSide(width: 1))),
                    gridData: const FlGridData(show: false),
                    barGroups: barGroups),
              );
  }
}