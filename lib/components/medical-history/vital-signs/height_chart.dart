import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HeightChart extends StatefulWidget {

  final List<VitalSignsData> list;

  const HeightChart({
    super.key,
    required this.list,
  });

  @override
  State<HeightChart> createState() => _HeightChartState();
}

class _HeightChartState extends State<HeightChart> {

  List<HeightData> createData() {
    List<VitalSignsData> lx = widget.list;
    List<HeightData> data = [];
    for (int i = 0; i < lx.length; i++) {
      NovaPatientVitalSignsDetail m = lx[i].novaPatientVitalSignsDetail!;
      int v1 = int.parse(m.value1!);
      data.add(HeightData(m.recordedDate!, v1));
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
              'Height (cm)',
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
        text: 'Height (cm)',
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
      series: <CartesianSeries<HeightData, String>>[
        LineSeries<HeightData, String>(
          color: kPrimaryColor,
          dataSource: createData(),
          xValueMapper: (HeightData m, _) => m.date,
          yValueMapper: (HeightData m, _) => m.value,
          name: 'Height',
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

class HeightData {

  final String date;
  final int value;

  HeightData(this.date, this.value);
}