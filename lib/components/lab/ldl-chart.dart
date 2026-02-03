import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class LDLChart extends StatefulWidget {

  final List<LabData> list;

  LDLChart({
    @required this.list,
  });

  @override
  _LDLChartState createState() => _LDLChartState();
}

class _LDLChartState extends State<LDLChart> {

  List<LDLData> createData() {
    var lx = widget.list;
    List<LDLData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i];
      double v1 = double.parse(m.resultValue);
      data.add(LDLData(m.recordedDate, v1));
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
              'LDL (mmol/L)',
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
        text: 'LDL (mmol/L)',
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
      series: <ChartSeries<LDLData, String>>[
        LineSeries<LDLData, String>(
          dataSource: createData(),
          xValueMapper: (LDLData m, _) => m.date,
          yValueMapper: (LDLData m, _) => m.value,
          name: 'LDL',
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

class LDLData {

  final String date;
  final double value;

  LDLData(this.date, this.value);
}