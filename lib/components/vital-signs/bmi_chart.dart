import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

import 'chart_helpers.dart';

class BMIChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const BMIChart({
    Key? key, 
    required this.list,
  }) : super(key: key);

  @override
  State<BMIChart> createState() => _BMIChartState();
}

class _BMIChartState extends State<BMIChart> {

  List<BMIData> createData() {
    var lx = widget.list;
    List<BMIData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i].novaPatientVitalSignsDetail!;
      double v1 = double.parse(m.value1!);
      data.add(BMIData(m.recordedDate!, v1));
    }

    return data;
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
              'BMI (kg/m\u00B2)',
              style: kTitleTextStyle.copyWith(
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'No data to display',
              style: kTitleTextStyle.copyWith(
                fontSize: 14.0,
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
        labelStyle: const TextStyle(
          fontFamily: kBodyFont,
        ),
      ),
      title: ChartTitle(
        text: 'BMI (kg/m\u00B2)',
        textStyle: kTitleTextStyle.copyWith(
          fontSize: 14.0,
        ),
      ),
      legend: Legend(
        isVisible: false,
        position: LegendPosition.top,
        textStyle: const TextStyle(
          fontFamily: kBodyFont,
        ),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: true,
        textStyle: const TextStyle(
          fontFamily: kBodyFont,
        ),
      ),
      series: <ChartSeries<BMIData, String>>[
        LineSeries<BMIData, String>(
          dataSource: createData(),
          xValueMapper: (BMIData m, _) => m.date,
          yValueMapper: (BMIData m, _) => m.value,
          name: 'BMI',
          markerSettings: const MarkerSettings(
            isVisible: true,
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            color: kHealthDashboardBgColor,
            textStyle: TextStyle(
              fontFamily: kBodyFont, 
              fontStyle: FontStyle.normal, 
              fontWeight: FontWeight.normal, 
              fontSize: 12.0,
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