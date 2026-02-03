import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class GlucoseChart extends StatefulWidget {

  final List<LabData> list;

  const GlucoseChart({
    Key? key, 
    required this.list,
  }) : super(key: key);

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
      primaryXAxis: CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
        labelStyle: const TextStyle(
          fontFamily: kBodyFont,
        ),
      ),
      title: ChartTitle(
        text: 'Glucose (mmol/L)',
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
      series: <ChartSeries<GlucoseData, String>>[
        LineSeries<GlucoseData, String>(
          dataSource: createData(),
          xValueMapper: (GlucoseData m, _) => m.date,
          yValueMapper: (GlucoseData m, _) => m.value,
          name: 'Glucose',
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

class GlucoseData {

  final String date;
  final double value;

  GlucoseData(this.date, this.value);
}