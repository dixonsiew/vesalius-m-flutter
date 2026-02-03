import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class GlucoseChart extends StatefulWidget {

  final List<LabData> list;

  const GlucoseChart({
    super.key, 
    required this.list,
  });

  @override
  State<GlucoseChart> createState() => _GlucoseChartState();
}

class _GlucoseChartState extends State<GlucoseChart> {
  
  List<GlucoseData> createData() {
    List<LabData> lx = widget.list;
    List<GlucoseData> data = [];
    for (int i = 0; i < lx.length; i++) {
      LabData m = lx[i];
      double v1 = double.parse(m.resultValue!);
      data.add(GlucoseData(m.recordedDate!, v1));
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
              'Glucose (mmol/L)',
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
        text: 'Glucose (mmol/L)',
        textStyle: kTextStyle1.copyWith(
          fontFamily: kFont2,
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
      series: <CartesianSeries<GlucoseData, String>>[
        LineSeries<GlucoseData, String>(
          color: kChartLineColor,
          dataSource: createData(),
          xValueMapper: (GlucoseData m, _) => m.date,
          yValueMapper: (GlucoseData m, _) => m.value,
          name: 'Glucose',
          markerSettings: const MarkerSettings(
            isVisible: true,
            borderColor: kChartLineColor,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            color: kSecondaryColor,
            textStyle: kTextStyle1.copyWith(
              fontFamily: kBodyFont,
              fontSize: 9.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      ],
    );
  }
}

class GlucoseData {

  final String date;
  final double value;

  GlucoseData(this.date, this.value);
}