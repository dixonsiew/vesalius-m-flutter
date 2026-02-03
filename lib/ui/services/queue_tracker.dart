import 'package:barcode_widget/barcode_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/queue_tracker_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/qms_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class QueueTracker extends StatefulWidget {

  const QueueTracker({super.key});

  @override
  State<QueueTracker> createState() => _QueueTrackerState();
}

class _QueueTrackerState extends State<QueueTracker> {

  ScrollController scr = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final QueueTrackerCtrl ctrl = Get.put(QueueTrackerCtrl());

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
      ctrl.setIsDown(false);
      List<QmsReq> lx = await QmsService.getAllQmsRequests();
      ctrl.setList(lx);
      ctrl.setIsLoading(false);
    }
    
    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.receiveTimeout) {
        ctrl.setIsDown(true);
      }

      else if (error.type == DioExceptionType.connectionError) {
        ctrl.setIsNoNetwork(true);
      }

      else if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 400) {
        ctrl.setIsDown(true);
      }

      else {
        handleError(error, load);
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildNoNetworkContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/icon/wifi.png',
                  width: 72.0,
                  height: 57.17,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'No Internet Connection',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 41.0),
                  child: Text(
                    'Sorry, we’re unable to retrieve your queue information. Please make sure you have a good network connection.',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB1B1B1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Try Again',
              onPressed: load,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSystemDownContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/error.png',
            width: 72.0,
            height: 72.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24.0),
          Text(
            'Something went wrong',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Sorry, our queue tracker is not available at the moment. We recommend you to :',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB1B1B1),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Stay outside of the clinic room',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB1B1B1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB1B1B1),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Wait for your name/number to be called',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB1B1B1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB1B1B1),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Kindly approach the counter staff if you have missed your turn.',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFB1B1B1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/error.png',
            width: 72.0,
            height: 72.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24.0),
          Text(
            'Queue not found',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 41.0),
            child: Text(
              'Sorry, you are not in any queue.\nPlease register at registration counter.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.isDown) {
      return buildSystemDownContent();
    }

    if (!ctrl.isLoading && ctrl.isNoNetwork) {
      return buildNoNetworkContent();
    }

    if (!ctrl.isLoading && ctrl.list.isEmpty && !ctrl.isDown && !ctrl.isNoNetwork) {
      return buildEmptyContent();
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: ctrl.list.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return const SizedBox(height: 24.0);
                }

                final o = ctrl.list[i - 1];
                return QueueItem(
                  key: ValueKey(o.queueNumber),
                  data: o,
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                load();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/icon/refresh.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Refresh Queue Status',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContent000() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 24.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.5),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.asset(
                          'images/imgs/qrbar.png',
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Queue Number',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              'B-6004',
                              style: kTextStyle1.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Patients ahead of you',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              '5',
                              style: kTextStyle1.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'As at',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              '11:30 AM',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1.0,
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Doctor Name',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              'Tan Sri Dato’ Dr Zain',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Room Number',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              'Room 212, Level 2',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.5),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.asset(
                          'images/imgs/qrbar.png',
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Queue Number',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              'C-6002',
                              style: kTextStyle1.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Patients ahead of you',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              '10',
                              style: kTextStyle1.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'As at',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              '11:30 AM',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1.0,
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Doctor Name',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              'Dr Chong Lin Wei',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Room Number',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor2,
                              ),
                            ),
                            Text(
                              'Room 200, Level 2',
                              style: kTextStyle1.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withValues(alpha: 0.1),
                        offset: const Offset(0.0, 4.0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/icon/info1.png',
                        width: 16.0,
                        height: 16.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'Please allow enough time to complete any assessment/test, if any. Your queue may not be called in sequence. Please update your particulars at the clinic if there are any changes.',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/icon/refresh.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Refresh Queue Status',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Queue Tracker',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class QueueItem extends StatelessWidget {

  final QmsReq data;

  const QueueItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withValues(alpha: 0.5),
            offset: const Offset(0.0, 4.0),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: data.queueNumber,
              height: 48.0,
              color: Colors.black,
              drawText: false,
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor4,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Queue Number',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor2,
                  ),
                ),
                Text(
                  data.queueNumber.toString(),
                  style: kTextStyle1.copyWith(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Queue Status',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor2,
                  ),
                ),
                Text(
                  data.ticketStatus,
                  style: kTextStyle1.copyWith(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Patients ahead of you',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor2,
                  ),
                ),
                Text(
                  data.patientsAheadOfYou,
                  style: kTextStyle1.copyWith(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'As at',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor2,
                  ),
                ),
                Text(
                  data.asAt,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor2,
                  ),
                ),
              ],
            ),
          ),
          if (data.relationship != 'self' && data.relationship != 'Self') ...[
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NOK',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor2,
                    ),
                  ),
                  Text(
                    data.patientName,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '   ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor2,
                    ),
                  ),
                  Text(
                    '(${data.relationship})',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor2,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          Container(
            height: 1.0,
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Doctor Name',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor2,
                  ),
                ),
                Text(
                  data.doctorName,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Room Number',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor2,
                  ),
                ),
                Text(
                  data.roomNumber,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E8E8).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: kBgColor2.withValues(alpha: 0.1),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/icon/info1.png',
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Queue numbers are provided as reference. Please note that the service order is subject to change due to unforeseen circumstances.',
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}