import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/services/way_finding_service.dart';
import 'package:zoomable_widget/zoomable_widget.dart' as zx;
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/way_finding_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/way_finding_data.dart';
import 'package:vesalius_m_flutter/ui/services/way-finding/search_location.dart';

import 'way-finding/map_view.dart';
import 'way-finding/qrscan.dart';

class WayFinding2 extends StatefulWidget {

  const WayFinding2({super.key});

  @override
  State<WayFinding2> createState() => _WayFinding2State();
}

class _WayFinding2State extends State<WayFinding2> {

  ScrollController scr = ScrollController();

  final WayFindingCtrl ctrl = Get.put(WayFindingCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      List<WayFinding> lx = await WayFindingService.getAllFloors();
      ctrl.setList(lx);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void loadRoute() async {
    try {
      if (ctrl.selectedLocationFrom == null || ctrl.selectedLocationTo == null) {
        return;
      }

      ctrl.setIsLoading(true);
      await ctrl.loadRoute();
      ctrl.setIsLoading(false);
      if (ctrl.route == null) {
        showNotFound();
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, loadRoute);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      await showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  void showNotFound() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/error1.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Unable to find a route',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Please check your destination or try a different route.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Got It',
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    ));
  }

  Color getSelectedFloorColor(WayFinding o) {
    Color c = ctrl.selectedFloor == o.floorCode ? Colors.white : Colors.black;
    if (ctrl.route != null) {
      if (ctrl.selectedLocationFrom?.locationFloorCode == ctrl.selectedFloor && o.floorCode == ctrl.selectedFloor) {
        c = Colors.white;
      }

      else if (ctrl.selectedLocationTo?.locationFloorCode == ctrl.selectedFloor && o.floorCode == ctrl.selectedFloor) {
        c = Colors.white;
      }
    }

    return c;
  }

  Color getSelectedFloorBgColor(WayFinding o) {
    Color c = ctrl.selectedFloor == o.floorCode ? kPrimaryColor : Colors.white;
    if (ctrl.route != null) {
      if (ctrl.selectedLocationFrom?.locationFloorCode == ctrl.selectedFloor && o.floorCode == ctrl.selectedFloor) {
        c = const Color(0xFF00ACFC);
      }

      if (ctrl.selectedLocationTo?.locationFloorCode == ctrl.selectedFloor && o.floorCode == ctrl.selectedFloor) {
        c = const Color(0xFFE1001A);
      }
    }

    return c;
  }

  List<Widget> buildList() {
    List<Widget> lx = [];
    for (int i = 0; i < ctrl.list.length; i++) {
      final w = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          ctrl.list[i].floorCode,
          style: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: getSelectedFloorColor(ctrl.list[i]),
          ),
        ),
      );
      BorderRadius? br;
      if (i == 0) {
        br = const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0));
      }

      else if (i == ctrl.list.length - 1) {
        br = const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0));
      }

      final k = Material(
        borderRadius: i == 0 || i == ctrl.list.length - 1 ? br : null,
        color: getSelectedFloorBgColor(ctrl.list[i]),
        child: InkWell(
          onTap: () {
            ctrl.setSelectedFloor(ctrl.list[i].floorCode);
          },
          borderRadius: i == 0 || i == ctrl.list.length - 1 ? br : null,
          child: w,
        ),
      );
      lx.add(k);
      if (i < ctrl.list.length - 1) {
        lx.add(
          Container(
            height: 1.0,
            color: const Color(0xFFDBDBDB),
          ),
        );
      }
    }

    return lx;
  }

  Widget buildImage() {
    if (ctrl.selectedFloor == '') {
      return Container();
    }

    final o = ctrl.list.firstWhere((x) => x.floorCode == ctrl.selectedFloor);
    String? image = o.floorImageRaw;
    if (ctrl.route != null) {
      if (ctrl.selectedFloor == ctrl.selectedLocationFrom?.locationFloorCode) {
        image = ctrl.route!.routeFromImageRaw;
      }

      if (ctrl.selectedFloor == ctrl.selectedLocationTo?.locationFloorCode) {
        image = ctrl.route!.routeToImageRaw;
      }
    }
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
      return GestureDetector(
        onTap: () {
          Get.to(() => MapView(data: data, floor: ctrl.selectedFloor));
        },
        child: im,
      );
    }

    return Container();
  }

  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24.0),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
              child: InkWell(
                onTap: () async {
                  await Get.to(() => const SearchLocation());
                  loadRoute();
                },
                borderRadius: BorderRadius.circular(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.5),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/icon/loc-blue.png',
                        width: 13.75,
                        height: 16.87,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Obx(() =>
                          Text(
                            ctrl.selectedLocationFrom == null ? 'Where are you now?' : '${ctrl.selectedLocationFrom?.locationFloorCode} - ${ctrl.selectedLocationFrom?.locationName}',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final res = await Get.to<String?>(() => const QrScan());
                          if (res != null) {
                            try {
                              final x = base64Decode(res);
                              String s = utf8.decode(x);
                              if (s.contains('IH-WAYFINDING-QR')) {
                                final ls = s.split(',');
                                try {
                                  ctrl.setIsLoading(true);
                                  Location? x = await WayFindingService.getLocationQr(ls[0], ls[1]);
                                  ctrl.setSelectedLocationFrom(x);
                                  ctrl.setIsLoading(false);
                                }

                                on DioException catch (error) {
                                  ctrl.setIsLoading(false);
                                  handleError(error, loadRoute);
                                }

                                catch (error) {
                                  ctrl.setIsLoading(false);
                                  await showCustomDialog('Error', error.toString(), 'Dismiss');
                                }
                              }

                              else {
                                showCustomDialog('Error', 'Invalid QR Code', 'Dismiss');
                              }
                            }

                            catch (_) {
                              showCustomDialog('Error', 'Invalid QR Code', 'Dismiss');
                            }
                          }
                        },
                        child: const Icon(Icons.qr_code_scanner_sharp),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
              child: InkWell(
                onTap: () async {
                  await Get.to(() => const SearchLocation(isFrom: false));
                  loadRoute();
                },
                borderRadius: BorderRadius.circular(50.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.5),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/icon/loc-red.png',
                        width: 13.75,
                        height: 16.87,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Obx(() =>
                          Text(
                            ctrl.selectedLocationTo == null ? 'Where do you wanna go?' : '${ctrl.selectedLocationTo?.locationFloorCode} - ${ctrl.selectedLocationTo?.locationName}',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: ctrl.selectedLocationFrom == null || ctrl.selectedLocationTo == null ? null : () {
                      //     final loc = ctrl.selectedLocationFrom;
                      //     ctrl.setSelectedLocationFrom(ctrl.selectedLocationTo);
                      //     ctrl.setSelectedLocationTo(loc);
                      //     loadRoute();
                      //   },
                      //   child: const Icon(Icons.swap_vert),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 80.0),

            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 35.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: buildList(),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: zx.Zoomable(
                        maxScale: 4,
                        minScale: 1,
                        panAxis: zx.PanAxis.free,
                        clipBehavior: Clip.hardEdge,
                        child: buildImage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Way Finding',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}