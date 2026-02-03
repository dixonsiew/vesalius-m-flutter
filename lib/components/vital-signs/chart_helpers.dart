import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

void onDataLabelRender(DataLabelRenderArgs m, List<VitalSignsData> list) {
  int i = m.pointIndex;
  var o = list[i];
  if (o.value1High != null && o.value1Low != null) {
    double v1 = double.parse(o.value1High!);
    double v2 = double.parse(o.value1Low!);
    double v = double.parse(o.novaPatientVitalSignsDetail!.value1!);
    if (v > v1) {
      m.color = Colors.red;
    }

    else if (v < v2) {
      m.color = Colors.green;
    }

    else {
      m.color = kHealthDashboardBgColor;
    }
  }

  else {
    m.color = kHealthDashboardBgColor;
  }
}

void onMarkerRender(MarkerRenderArgs m, List<VitalSignsData> list) {
  int i = m.pointIndex!;
  var o = list[i];
  if (o.value1High != null && o.value1Low != null) {
    double v1 = double.parse(o.value1High!);
    double v2 = double.parse(o.value1Low!);
    double v = double.parse(o.novaPatientVitalSignsDetail!.value1!);
    if (v > v1) {
      m.shape = DataMarkerType.triangle;
      m.color = Colors.red;
      m.borderColor = Colors.red;
      m.markerWidth = 10.0;
      m.markerHeight = 10.0;
    }

    else if (v < v2) {
      m.shape = DataMarkerType.invertedTriangle;
      m.color = Colors.green;
      m.borderColor = Colors.green;
      m.markerWidth = 10.0;
      m.markerHeight = 10.0;
    }
  }
}