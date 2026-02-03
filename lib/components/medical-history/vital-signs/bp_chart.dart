import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class BPChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const BPChart({
    super.key, 
    required this.list,
  });

  @override
  State<BPChart> createState() => _BPChartState();
}

class _BPChartState extends State<BPChart> {

 List<BPData> createData() {
    List<VitalSignsData> lx = widget.list;
    List<BPData> data = [];
    for (int i = 0; i < lx.length; i++) {
      NovaPatientVitalSignsDetail m = lx[i].novaPatientVitalSignsDetail!;
      int v1 = int.parse(m.value1!);
      data.add(BPData(m.recordedDate!, v1));
    }

    return data;
  }

  List<BPData> createData2() {
    List<VitalSignsData> lx = widget.list;
    List<BPData> data = [];
    for (int i = 0; i < lx.length; i++) {
      NovaPatientVitalSignsDetail m = lx[i].novaPatientVitalSignsDetail!;
      int v1 = int.parse(m.value2!);
      data.add(BPData(m.recordedDate!, v1));
    }

    return data;
  }

  void onDataLabelRender(DataLabelRenderArgs m) {
    int i = m.pointIndex;
    CartesianSeriesRenderer<BPData, String> s = m.seriesRenderer;
    VitalSignsData o = widget.list[i];
    if (o.value1High != null && o.value1Low != null && s.name == 'Systolic') {
      double v1 = double.parse(o.value1High!);
      double v2 = double.parse(o.value1Low!);
      double v = double.parse(o.novaPatientVitalSignsDetail!.value1!);
      if (v > v1) {
        m.color = Colors.red;
      }

      else if (v < v2) {
        m.color = Colors.green;
      }

      else {
        m.color = kColor27.withValues(alpha: 0.5);
      }
    }

    else if (o.value2High != null && o.value2Low != null && s.name == 'Diastolic') {
      double v1 = double.parse(o.value2High!);
      double v2 = double.parse(o.value2Low!);
      double v = double.parse(o.novaPatientVitalSignsDetail!.value2!);
      if (v > v1) {
        m.color = Colors.red;
      }

      else if (v < v2) {
        m.color = Colors.green;
      }

      else {
        m.color = kSecondaryColor;
        m.textStyle = kTextStyle1.copyWith(
          fontFamily: kBodyFont, 
          fontSize: 9.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        );
      }
    }

    else {
      m.color = kSecondaryColor;
      m.textStyle = kTextStyle1.copyWith(
        fontFamily: kBodyFont, 
        fontSize: 9.0,
        fontWeight: FontWeight.w600,
        color: kTextColor1,
      );
    }
  }

  void onMarkerRender(MarkerRenderArgs m) {
    int i = m.pointIndex!;
    int j = m.seriesIndex!;
    VitalSignsData o = widget.list[i];
    if (o.value1High != null && o.value1Low != null && j == 0) {
      double v1 = double.parse(o.value1High!);
      double v2 = double.parse(o.value1Low!);
      double v = double.parse(o.novaPatientVitalSignsDetail!.value1!);
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
      double v1 = double.parse(o.value2High!);
      double v2 = double.parse(o.value2Low!);
      double v = double.parse(o.novaPatientVitalSignsDetail!.value2!);
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
    final a = s.split(',');
    if (a.isNotEmpty && a.isNotEmpty) {
      s = a.first;
    }

    return ChartAxisLabel(s, x.textStyle);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Blood Pressure (mmHg)',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'No data to display',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
          ],
        ),
      );
    }

    return SfCartesianChart(
      onDataLabelRender: onDataLabelRender,
      onMarkerRender: onMarkerRender,
      primaryXAxis: CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
        labelStyle: kTextStyle1.copyWith(
          fontFamily: kBodyFont,
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
        axisLabelFormatter: axisLabelFormatter,
      ),
      title: ChartTitle(
        text: 'Blood Pressure (mmHg)',
        textStyle: kTextStyle1.copyWith(
          fontFamily: kBodyFont,
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kTextColor1,
        ),
      ),
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.top,
        textStyle: TextStyle(
          fontFamily: kBodyFont,
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: kTextColor4,
        ),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: true,
        textStyle: const TextStyle(
          fontFamily: kBodyFont,
        ),
      ),
      series: <CartesianSeries<BPData, String>>[
        LineSeries<BPData, String>(
          color: kChartLineColor,
          dataSource: createData(),
          xValueMapper: (BPData m, _) => m.date,
          yValueMapper: (BPData m, _) => m.value,
          name: 'Systolic',
          markerSettings: const MarkerSettings(
            isVisible: true,
            borderColor: kChartLineColor,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: kTextStyle1.copyWith(
              fontFamily: kBodyFont,
              fontSize: 9.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        LineSeries<BPData, String>(
          color: kPrimaryColor2,
          dataSource: createData2(),
          xValueMapper: (BPData m, _) => m.date,
          yValueMapper: (BPData m, _) => m.value,
          name: 'Diastolic',
          markerSettings: const MarkerSettings(
            isVisible: true,
            borderColor: kPrimaryColor2,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: kTextStyle1.copyWith(
              fontFamily: kBodyFont, 
              fontSize: 9.0,
              fontWeight: FontWeight.w600,
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