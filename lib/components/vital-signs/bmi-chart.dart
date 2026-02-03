import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

import 'chart-helpers.dart';

class BMIChart extends StatefulWidget {

  final List<VitalSignsData> list;

  BMIChart({
    @required this.list,
  });

  @override
  _BMIChartState createState() => _BMIChartState();
}

class _BMIChartState extends State<BMIChart> {

  List<BMIData> createData() {
    var lx = widget.list;
    List<BMIData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i].novaPatientVitalSignsDetail;
      double v1 = double.parse(m.value1);
      data.add(BMIData(m.recordedDate, v1));
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
              'BMI (kg/m\u00B2)',
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
      onDataLabelRender: (DataLabelRenderArgs m) => onDataLabelRender(m, widget.list),
      onMarkerRender: (MarkerRenderArgs m) => onMarkerRender(m, widget.list),
      primaryXAxis: CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
      ),
      title: ChartTitle(
        text: 'BMI (kg/m\u00B2)',
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
      series: <ChartSeries<BMIData, String>>[
        LineSeries<BMIData, String>(
          dataSource: createData(),
          xValueMapper: (BMIData m, _) => m.date,
          yValueMapper: (BMIData m, _) => m.value,
          name: 'BMI',
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

class BMIData {

  final String date;
  final double value;

  BMIData(this.date, this.value);
}