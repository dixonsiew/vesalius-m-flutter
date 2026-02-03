import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class WeightChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const WeightChart({
    super.key,  
    required this.list,
  });

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {

  List<WeightData> createData() {
    List<VitalSignsData> lx = widget.list;
    List<WeightData> data = [];
    for (int i = 0; i < lx.length; i++) {
      NovaPatientVitalSignsDetail m = lx[i].novaPatientVitalSignsDetail!;
      double v1 = double.parse(m.value1!);
      data.add(WeightData(m.recordedDate!, v1));
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
              'Weight (kg)',
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
        text: 'Weight (kg)',
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
      series: <CartesianSeries<WeightData, String>>[
        LineSeries<WeightData, String>(
          color: kChartLineColor,
          dataSource: createData(),
          xValueMapper: (WeightData m, _) => m.date,
          yValueMapper: (WeightData m, _) => m.value,
          name: 'Weight',
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

class WeightData {

  final String date;
  final double value;

  WeightData(this.date, this.value);
}