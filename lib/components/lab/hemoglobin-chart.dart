import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class HemoglobinChart extends StatefulWidget {

  final List<LabData> list;

  HemoglobinChart({
    @required this.list,
  });

  @override
  _HemoglobinChartState createState() => _HemoglobinChartState();
}

class _HemoglobinChartState extends State<HemoglobinChart> {

  List<HemoglobinData> createData() {
    var lx = widget.list;
    List<HemoglobinData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i];
      double v1 = double.parse(m.resultValue);
      data.add(HemoglobinData(m.recordedDate, v1));
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hemoglobin (mmol/L)',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 102, 102, 102),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'No data to display',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF585656),
              ),
            ),
          ],
        ),
      );
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
      ),
      title: ChartTitle(
        text: 'Hemoglobin (mmol/L)',
        textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      legend: Legend(
        isVisible: false,
        position: LegendPosition.top,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: true,
      ),
      series: <ChartSeries<HemoglobinData, String>>[
        LineSeries<HemoglobinData, String>(
          dataSource: createData(),
          xValueMapper: (HemoglobinData m, _) => m.date,
          yValueMapper: (HemoglobinData m, _) => m.value,
          name: 'Hemoglobin',
          markerSettings: MarkerSettings(
            isVisible: true,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            color: kHealthDashboardBgColor,
            textStyle: TextStyle(
              fontFamily: 'Roboto', 
              fontStyle: FontStyle.normal, 
              fontWeight: FontWeight.normal, 
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class HemoglobinData {

  final String date;
  final double value;

  HemoglobinData(this.date, this.value);
}