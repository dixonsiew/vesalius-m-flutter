import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:zoomable_widget/zoomable_widget.dart' as zx;

class MapView extends StatelessWidget {

  final String data;
  final String floor;

  const MapView({
    super.key,
    required this.data,
    required this.floor,
  });

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: floor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: zx.Zoomable(
            maxScale: 4,
            minScale: 1,
            panAxis: zx.PanAxis.free,
            clipBehavior: Clip.hardEdge,
            child: Image.memory(
              base64Decode(data),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}