import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

import 'chart_helpers.dart';

class BMIChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const BMIChart({
    super.key, 
    required this.list,
  });

  @override
  State<BMIChart> createState() => _BMIChartState();
}

class _BMIChartState extends State<BMIChart> {

  List<BMIData> createData() {
    List<VitalSignsData> lx = widget.list;
    List<BMIData> data = [];
    for (int i = 0; i < lx.length; i++) {
      NovaPatientVitalSignsDetail m = lx[i].novaPatientVitalSignsDetail!;
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
      onDataLabelRender: (DataLabelRenderArgs m) => onDataLabelRender(m, widget.list),
      onMarkerRender: (MarkerRenderArgs m) => onMarkerRender(m, widget.list),
      primaryXAxis: CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
        labelStyle: kTextStyle1.copyWith(
          fontFamily: kBodyFont,
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
      ),
      title: ChartTitle(
        text: 'BMI (kg/m\u00B2)',
        textStyle: kTextStyle1.copyWith(
          fontFamily: kBodyFont,
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kTextColor1,
        ),
      ),
      legend: const Legend(
        isVisible: false,
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
      series: <CartesianSeries<BMIData, String>>[
        LineSeries<BMIData, String>(
          color: kPrimaryColor,
          dataSource: createData(),
          xValueMapper: (BMIData m, _) => m.date,
          yValueMapper: (BMIData m, _) => m.value,
          name: 'BMI',
          markerSettings: const MarkerSettings(
            isVisible: true,
            borderColor: kPrimaryColor,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
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

class BMIData {

  final String date;
  final double value;

  BMIData(this.date, this.value);
}