import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:zoomable_widget/zoomable_widget.dart' as zx;
import 'package:vesalius_m_flutter/models/way_finding_data.dart' as wf;

class MapViewRoute extends StatefulWidget {

  final wf.Route data;
  final wf.Location from;
  final wf.Location to;

  const MapViewRoute({
    super.key,
    required this.data,
    required this.from,
    required this.to,
  });

  @override
  State<MapViewRoute> createState() => _MapViewRouteState();
}

class _MapViewRouteState extends State<MapViewRoute> {

  ScrollController scr = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  String getTitle() {
    String s = '${widget.from.locationName} to ${widget.to.locationName}';
    return s;
  }

  String getDesc() {
    String s = '${widget.from.locationFloorCode} - ${widget.from.locationName} to ${widget.to.locationFloorCode} - ${widget.to.locationName}';
    return s;
  }

  Widget buildImageFrom() {
    String? image = widget.data.routeFromImageRaw;
    Widget w = Container();
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      Image im = Image.memory(
        base64Decode(data),
        fit: BoxFit.contain,
      );
      w = zx.Zoomable(
        maxScale: 4,
        minScale: 1,
        panAxis: zx.PanAxis.free,
        clipBehavior: Clip.hardEdge,
        child: im,
      );
    }

    return w;
  }

  Widget buildImageTo() {
    String? image = widget.data.routeToImageRaw;
    Widget w = Container();
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      Image im = Image.memory(
        base64Decode(data),
        fit: BoxFit.contain,
      );
      w = zx.Zoomable(
        maxScale: 4,
        minScale: 1,
        panAxis: zx.PanAxis.free,
        clipBehavior: Clip.hardEdge,
        child: im,
      );
    }

    return w;
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: getTitle(),
      body: SafeArea(
        child: Scrollbar(
          controller: scr,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const SizedBox(height: 24.0),
                  // Text(
                  //   getDesc(),
                  //   style: kTextStyle1.copyWith(
                  //     fontSize: 14.0,
                  //     fontWeight: FontWeight.w400,
                  //     color: kTextColor2,
                  //   ),
                  // ),
                  buildImageFrom(),
                  if (widget.data.routeToImageRaw != null && widget.data.routeToImageRaw != '') ...[
                    buildImageTo(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}