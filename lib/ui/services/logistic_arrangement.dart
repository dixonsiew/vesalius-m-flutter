import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic_arrangement_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/services/logistic_service.dart';

import 'logistic-arrangement/tnc.dart';

class LogisticArrangement extends StatefulWidget {

  static const String routeName = '/LogisticArrangement';

  const LogisticArrangement({super.key});

  @override
  State<LogisticArrangement> createState() => _LogisticArrangementState();
}

class _LogisticArrangementState extends State<LogisticArrangement> {

  String tnc = '';
  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final LogisticArrangementCtrl ctrl = Get.put(LogisticArrangementCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(scrollListener);
    load();
  }

  @override
  void dispose() {
    scr.removeListener(scrollListener);
    scr.dispose();
    super.dispose();
  }

  void scrollListener() {
    final nextPageTrigger = 0.8 * scr.position.maxScrollExtent;
    if (scr.position.pixels > nextPageTrigger) {
      loadMore();
    }
  }

  void load() async {
    try {
      ctrl.init();
      ctrl.setIsLoading(true);
      await ctrl.load();
      tnc = await LogisticService.getTnC();
      tnc = tnc.replaceAll('*', '•');
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

  void loadMore() async {
    int p = ctrl.page + 1;
    try {
      if (ctrl.isLoadingMore) return;
      ctrl.setIsLoadingMore(true);
      List<LogisticRequest> lx = await LogisticService.getAllLogisticRequests(p, kPageSize);
      if (lx.isEmpty) {
        ctrl.setIsLoadingMore(false);
        return;
      }

      ctrl.setPage(p);
      ctrl.setList(lx);
      ctrl.setIsLoadingMore(false);
    }
    
    on DioException catch (error) {
      ctrl.setIsLoadingMore(false);
      handleLoadError(error, loadMore);
    }

    catch (error) {
      ctrl.setIsLoadingMore(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  void onSubmitCancel(LogisticRequest x) async {
    try {
      bool b = await showCancel();
      if (b == false) {
        return;
      }

      ctrl.setIsLoading(true);
      final o = {
        'status': 'Cancelled',
        'requestNumber': x.logisticRequestNumber 
      };
      await LogisticService.postLogisticRequestStatus(o);
      ctrl.init();
      await ctrl.load();
      ctrl.setIsLoading(false);
      showSuccessCancel();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to cancel request at the moment. Please check your internet connection or try again later.', () => onSubmitCancel(x));
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to cancel request at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void showSuccessCancel() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Request Cancel Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your airport pickup request has been cancelled.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  Future<bool> showCancel() async {
    return await Get.dialog(AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Are you sure want to cancel this airport pickup request?',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Sure',
                    onPressed: () => Get.back(result: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? false;
  }

  void onSubmit() {
    Get.to(() => TnC(data: tnc, showAgree: true));
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoLogisticArrangement(onRefresh: onRefresh);
    }

    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Obx(() =>
          ListView.builder(
            controller: scr,
            shrinkWrap: true,
            itemCount: ctrl.list.length + 1,
            itemBuilder: (context, i) {
              if (i == ctrl.list.length) {
                return Obx(() => ctrl.isLoadingMore ? const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: AppLoadMoreIndicator(),
                ) : Container());
              }
          
              final o = ctrl.list[i];
              return LogisticArrangementItem(
                key: ValueKey(o.logisticRequestNumber),
                data: o,
                onCancel: () {
                  onSubmitCancel(o);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Airport Pickup',
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
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: onSubmit,
            icon: const Icon(
              Icons.add_circle_rounded,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class LogisticArrangementItem extends StatefulWidget {

  final LogisticRequest data;
  final void Function() onCancel;

  const LogisticArrangementItem({
    super.key,
    required this.data,
    required this.onCancel,
  });

  @override
  State<LogisticArrangementItem> createState() => _LogisticArrangementItemState();
}

class _LogisticArrangementItemState extends State<LogisticArrangementItem> {

  bool showMore = false;

  Color get statusBgColor {
    final String s = widget.data.logisticRequestStatus;
    Color c = const Color(0xFFD4E8E8).withValues(alpha: 0.5);
    if (s == 'Rejected') {
      c = const Color(0xFFFFE2E2);
    }

    else if (s == 'Cancelled') {
      c = const Color(0xFFDADADA);
    }

    return c;
  }

  Color get statusTextColor {
    final String s = widget.data.logisticRequestStatus;
    Color c = kPrimaryColor;
    if (s == 'Rejected') {
      c = const Color(0xFFFF0000);
    }

    else if (s == 'Cancelled') {
      c = kTextColor6;
    }

    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(219, 219, 219, 0.45)),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(229, 229, 229, 0.5),
            offset: Offset(0.0, 4.0),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Patient Name',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: statusBgColor,
                ),
                child: Text(
                  widget.data.logisticRequestStatus,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: statusTextColor,
                  ),
                ),
              ),
            ],
          ),
          Text(
            widget.data.requesterName,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
          const SizedBox(height: 16.0),

          Text(
            'Doctor Name',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
          ),
          Text(
            widget.data.primaryDoctorName ?? '-',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
          const SizedBox(height: 16.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Requested Pickup Date',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Requested Pickup Time',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.data.requestedPickupDate,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.data.requestedPickupTime,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),

          if (showMore) ...[
            Container(
              height: 1.0,
              margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
            ),

            Text(
              'Flight Details',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 16.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Airline Name',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Flight Number',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.data.flightAirlineName,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.data.flightNumber,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Flight Arrival Date',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Flight Arrival Time',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.data.flightArrivalDate,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.data.flightArrivalTime,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16.0),
            Container(
              height: 1.0,
              color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16.0),

            Text(
              'Companion Info',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 16.0),

            Text(
              'Name',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
            ),
            Text(
              widget.data.companionName ?? '-',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
          ],

          const SizedBox(height: 24.0),
          if (widget.data.displayCancelBtn) ...[
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButtonSm(
                    text: 'Cancel',
                    onPressed: widget.onCancel,
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButtonSm(
                    text: showMore ? 'Less Info' : 'More Info',
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    }
                  ),
                ),
              ],
            ),
          ] else ...[
            AppElevatedButtonSm(
              text: showMore ? 'Less Info' : 'More Info',
              onPressed: () {
                setState(() {
                  showMore = !showMore;
                });
              }
            ),
          ],
        ],
      ),
    );
  }
}

class NoLogisticArrangement extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoLogisticArrangement({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/airplane.png',
            width: 80.0,
            height: 58.33,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'No airport pickup arrangement found at the moment.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}