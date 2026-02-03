import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HemoglobinChart extends StatefulWidget {

  final List<LabData> list;

  const HemoglobinChart({
    super.key, 
    required this.list,
  });

  @override
  State<HemoglobinChart> createState() => _HemoglobinChartState();
}

class _HemoglobinChartState extends State<HemoglobinChart> {

  List<HemoglobinData> createData() {
    List<LabData> lx = widget.list;
    List<HemoglobinData> data = [];
    for (int i = 0; i < lx.length; i++) {
      LabData m = lx[i];
      double v1 = double.parse(m.resultValue!);
      data.add(HemoglobinData(m.recordedDate!, v1));
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
              'Hemoglobin (mmol/L)',
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
        text: 'Hemoglobin (mmol/L)',
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
      series: <CartesianSeries<HemoglobinData, String>>[
        LineSeries<HemoglobinData, String>(
          color: kPrimaryColor,
          dataSource: createData(),
          xValueMapper: (HemoglobinData m, _) => m.date,
          yValueMapper: (HemoglobinData m, _) => m.value,
          name: 'Hemoglobin',
          markerSettings: const MarkerSettings(
            isVisible: true,
            borderColor: kPrimaryColor,
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

class HemoglobinData {

  final String date;
  final double value;

  HemoglobinData(this.date, this.value);
}