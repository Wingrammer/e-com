import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management_system/models/consultation.dart';

class MyLineChart extends StatefulWidget {
  final List<Consultation> consultations = [];
  MyLineChart({Key? key, List<Consultation>? consultations}) : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.green, width: 4),
            left: BorderSide(color: Colors.transparent),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: leftTitleWidgets,
              showTitles: true,
              interval: 1,
              reservedSize: 40,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: const Color(0xff4af699),
            barWidth: 8,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: List.generate(30, (index) => FlSpot(
              index.toDouble(),
              widget.consultations
                .where((element) => element.isDate(dates[index]))
                .length
                .toDouble(),
            ))/*dates.map((e) {
              print(e.day.toDouble());
              return FlSpot(
                e.day.toDouble(),
                widget.consultations
                    .where((element) => element.isDate(e))
                    .length
                    .toDouble(),
              );
            }).toList(),*/
          ),
        ],
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 10:
        text = '10';
        break;
      case 20:
        text = '20';
        break;
      case 30:
        text = '30';
        break;
      case 40:
        text = '50';
        break;
      case 50:
        text = '60';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text = Text('${dates[value.toInt()].day}', style: style,);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 7,
      child: text,
    );
  }

  List<DateTime> get dates{
    List<DateTime> dates = [];
    DateTime today = DateTime.now();
    for(int i = 29; i>=0; i--){
      dates.add(today.subtract(Duration(days: i)));
    }
    return dates;
  }

}
