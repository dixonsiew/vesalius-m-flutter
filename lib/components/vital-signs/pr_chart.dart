import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/components/vital-signs/chart_helpers.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class PRChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const PRChart({
    Key? key, 
    required this.list,
  }) : super(key: key);

  @override
  State<PRChart> createState() => _PRChartState();
}

class _PRChartState extends State<PRChart> {

  List<PRData> createData() {
    List<VitalSignsData> lx = widget.list;
    List<PRData> data = [];
    for (int i = 0; i < lx.length; i++) {
      NovaPatientVitalSignsDetail m = lx[i].novaPatientVitalSignsDetail!;
      int v1 = int.parse(m.value1!);
      data.add(PRData(m.recordedDate!, v1));
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
              'Pulse Rate (bpm)',
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
        text: 'Pulse Rate (bpm)',
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
      series: <ChartSeries<PRData, String>>[
        LineSeries<PRData, String>(
          dataSource: createData(),
          xValueMapper: (PRData m, _) => m.date,
          yValueMapper: (PRData m, _) => m.value,
          name: 'Pulse Rate',
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

class PRData {

  final String date;
  final int value;

  PRData(this.date, this.value);
}