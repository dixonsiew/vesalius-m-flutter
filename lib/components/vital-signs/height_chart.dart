import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HeightChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const HeightChart({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<HeightChart> createState() => _HeightChartState();
}

class _HeightChartState extends State<HeightChart> {

  List<HeightData> createData() {
    var lx = widget.list;
    List<HeightData> data = [];
    for (int i = 0; i < lx.length; i++) {
      var m = lx[i].novaPatientVitalSignsDetail!;
      num v1 = num.parse(m.value1!);
      data.add(HeightData(m.recordedDate!, v1.toDouble()));
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
              'Height (cm)',
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
        text: 'Height (cm)',
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
      series: <CartesianSeries<HeightData, String>>[
        LineSeries<HeightData, String>(
          dataSource: createData(),
          xValueMapper: (HeightData m, _) => m.date,
          yValueMapper: (HeightData m, _) => m.value,
          name: 'Height',
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

class HeightData {

  final String date;
  final double value;

  HeightData(this.date, this.value);
}