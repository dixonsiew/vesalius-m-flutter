import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class BPChart extends StatefulWidget {

  final List<VitalSignsData> list;

  BPChart({
    @required this.list,
  });

  @override
  _BPChartState createState() => _BPChartState();
}

class _BPChartState extends State<BPChart> {

 List<BPData> createData() {
    var lx = widget.list;
    List<BPData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i].novaPatientVitalSignsDetail;
      int v1 = int.parse(m.value1);
      data.add(BPData(m.recordedDate, v1));
    }

    return data;
  }

  List<BPData> createData2() {
    var lx = widget.list;
    List<BPData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i].novaPatientVitalSignsDetail;
      int v1 = int.parse(m.value2);
      data.add(BPData(m.recordedDate, v1));
    }

    return data;
  }

  void onDataLabelRender(DataLabelRenderArgs m) {
    int i = m.pointIndex;
    CartesianSeries<dynamic, dynamic> s = m.seriesRenderer;
    var o = widget.list[i];
    if (o.value1High != null && o.value1Low != null && s.name == 'Systolic') {
      double v1 = double.parse(o.value1High);
      double v2 = double.parse(o.value1Low);
      double v = double.parse(o.novaPatientVitalSignsDetail.value1);
      if (v > v1) {
        m.color = Colors.red;
      }

      else if (v < v2) {
        m.color = Colors.green;
      }

      else {
        m.color = kHealthDashboardBgColor;
      }
    }

    else if (o.value2High != null && o.value2Low != null && s.name == 'Diastolic') {
      double v1 = double.parse(o.value2High);
      double v2 = double.parse(o.value2Low);
      double v = double.parse(o.novaPatientVitalSignsDetail.value2);
      if (v > v1) {
        m.color = Colors.red;
      }

      else if (v < v2) {
        m.color = Colors.green;
      }

      else {
        m.color = kHealthDashboardBgColor;
      }
    }

    else {
      m.color = kHealthDashboardBgColor;
    }
  }

  void onMarkerRender(MarkerRenderArgs m) {
    int i = m.pointIndex;
    int j = m.seriesIndex;
    var o = widget.list[i];
    if (o.value1High != null && o.value1Low != null && j == 0) {
      double v1 = double.parse(o.value1High);
      double v2 = double.parse(o.value1Low);
      double v = double.parse(o.novaPatientVitalSignsDetail.value1);
      if (v > v1) {
        m.shape = DataMarkerType.triangle;
        m.color = Colors.red;
        m.borderColor = Colors.red;
        m.markerWidth = 10.0;
        m.markerHeight = 10.0;
      }

      else if (v < v2) {
        m.shape = DataMarkerType.invertedTriangle;
        m.color = Colors.green;
        m.borderColor = Colors.green;
        m.markerWidth = 10.0;
        m.markerHeight = 10.0;
      }
    }

    else if (o.value2High != null && o.value2Low != null && j == 1) {
      double v1 = double.parse(o.value2High);
      double v2 = double.parse(o.value2Low);
      double v = double.parse(o.novaPatientVitalSignsDetail.value2);
      if (v > v1) {
        m.shape = DataMarkerType.triangle;
        m.color = Colors.red;
        m.borderColor = Colors.red;
        m.markerWidth = 10.0;
        m.markerHeight = 10.0;
      }

      else if (v < v2) {
        m.shape = DataMarkerType.invertedTriangle;
        m.color = Colors.green;
        m.borderColor = Colors.green;
        m.markerWidth = 10.0;
        m.markerHeight = 10.0;
      }
    }

    else {
      m.color = Colors.cyan;
    }
  }

  ChartAxisLabel axisLabelFormatter(AxisLabelRenderDetails x) {
    String s = x.text;
    if (x.axisName == 'primaryXAxis') {
      final a = s.split(',');
      if (a.isNotEmpty && a.length > 0) {
        s = a.first;
      }
    }

    return ChartAxisLabel(s, x.textStyle);
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
              'Blood Pressure (mmHg)',
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
      onDataLabelRender: onDataLabelRender,
      onMarkerRender: onMarkerRender,
      axisLabelFormatter: axisLabelFormatter,
      primaryXAxis: CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
      ),
      title: ChartTitle(
        text: 'Blood Pressure (mmHg)',
        textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: true,
      ),
      series: <ChartSeries<BPData, String>>[
        LineSeries<BPData, String>(
          dataSource: createData(),
          xValueMapper: (BPData m, _) => m.date,
          yValueMapper: (BPData m, _) => m.value,
          name: 'Systolic',
          markerSettings: MarkerSettings(
            isVisible: true,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
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
        LineSeries<BPData, String>(
          color: Colors.blue,
          dataSource: createData2(),
          xValueMapper: (BPData m, _) => m.date,
          yValueMapper: (BPData m, _) => m.value,
          name: 'Diastolic',
          markerSettings: MarkerSettings(
            isVisible: true,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
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

class BPData {

  final String date;
  final int value;

  BPData(this.date, this.value);
}