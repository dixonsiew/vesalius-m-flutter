import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class WeightChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const WeightChart({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {

  List<WeightData> createData() {
    var lx = widget.list;
    List<WeightData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i].novaPatientVitalSignsDetail!;
      double v1 = double.parse(m.value1!);
      data.add(WeightData(m.recordedDate!, v1));
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weight (kg)',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: kTitleFont,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 102, 102, 102),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'No data to display',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: kTitleFont,
                color: Color(0xFF585656),
              ),
            ),
          ],
        ),
      );
    }

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        arrangeByIndex: true,
        labelRotation: 25,
        labelStyle: TextStyle(
          fontFamily: kBodyFont,
        ),
      ),
      title: const ChartTitle(
        text: 'Weight (kg)',
        textStyle: TextStyle(
          fontSize: 14.0,
          fontFamily: kTitleFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      legend: const Legend(
        isVisible: false,
        position: LegendPosition.top,
        textStyle: TextStyle(
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
      series: <CartesianSeries<WeightData, String>>[
        LineSeries<WeightData, String>(
          dataSource: createData(),
          xValueMapper: (WeightData m, _) => m.date,
          yValueMapper: (WeightData m, _) => m.value,
          name: 'Weight',
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
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class WeightData {

  final String date;
  final double value;

  WeightData(this.date, this.value);
}