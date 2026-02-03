import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/outpatient-bill/unpaid_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/bill_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

import 'billing_detail.dart';

class Unpaid extends StatefulWidget {

  const Unpaid({super.key});

  @override
  State<Unpaid> createState() => _UnpaidState();
}

class _UnpaidState extends State<Unpaid> with AutomaticKeepAliveClientMixin<Unpaid> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final UnpaidCtrl ctrl = Get.put(UnpaidCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
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
      final branchDetails = DataManager.instance.branchDetails!;
      final o = await VesaliusService.getOutstandingBills(branchDetails.branch!.branchId!, branchDetails.prn!);
      ctrl.setData(o);
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

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.data == null) {
      return NoUnpaid(onRefresh: onRefresh);
    }

    if (!ctrl.isLoading && ctrl.data != null && ctrl.data!.bills.isEmpty) {
      return NoUnpaid(onRefresh: onRefresh);
    }

    return Scrollbar(
      controller: scr,
      child: Obx(() =>
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            controller: scr,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: ctrl.data?.bills.length ?? 0,
            itemBuilder: (context, i) {
              final o = ctrl.data?.bills[i];
              return UnpaidItem(
                key: ValueKey(o!.billNumber),
                data: o,
                billInfo: ctrl.data!,
              );
            }
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
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
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class UnpaidItem extends StatefulWidget {

  final Bill data;
  final OutstandingBill billInfo;

  const UnpaidItem({
    super.key,
    required this.data,
    required this.billInfo,
  });

  @override
  State<UnpaidItem> createState() => _UnpaidItemState();
}

class _UnpaidItemState extends State<UnpaidItem> {

  bool isDownloading = false;
  ValueNotifier<int> percentNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    percentNotifier.dispose();
    super.dispose();
  }

  void onBillDetails() async {
    try {
      percentNotifier.value = 0;
      setState(() {
        isDownloading = true;
      });
      final branchDetails = DataManager.instance.branchDetails;
      final dir = await getApplicationDocumentsDirectory();
      String fp = '${dir.path}/${widget.data.billNumber}.pdf';
      File file = await VesaliusService.getOutstandingBillPdf(branchDetails!.branch!.branchId!, widget.billInfo.prn, widget.data.billNumber, fp, (received, total) async {
        if (total != -1) {
          double pct = received / total;
          percentNotifier.value = (pct * 100).floor();
        }
      });
      setState(() {
        isDownloading = false;
      });
      await OpenFilex.open(file.path);
    }

    on DioException catch (error) {
      setState(() {
        isDownloading = false;
      });
      handleLoadError(error, onBillDetails);
    }

    catch (error) {
      setState(() {
        isDownloading = false;
      });
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Reg Date Time',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.data.regDateTime,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Bill Number',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.data.billNumber,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Invoice Number',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.data.invoiceNumber,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Invoice Date Time',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.data.billInvoiceDateTime,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Total Bill',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'RM ${widget.data.billAmount}',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Invoice Amount',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'RM ${widget.data.invoiceAmount}',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1.0,
            margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            color: kColor11.withValues(alpha: 0.5),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Outstanding Amount',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'RM ${widget.data.outstandingAmount}',
                  style: kTextStyle1.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: AppOutlinedButtonSm(
                  text: 'Bill Summary',
                  onPressed: onBillDetails,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: AppElevatedButtonSm(
                  text: 'Pay Now',
                  onPressed: () {
                    Get.to(() => BillingDetail(data: widget.data));
                  }
                ),
              ),
            ],
          ),
          if (isDownloading) ...[
            const SizedBox(height: 5.0),
            ValueListenableBuilder(
              valueListenable: percentNotifier,
              builder: (context, value, child) {
                return LinearPercentIndicator(
                  lineHeight: 16.0,
                  percent: percentNotifier.value / 100,
                  center: Text(
                    '${percentNotifier.value} %',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  barRadius: const Radius.circular(16.0),
                  backgroundColor: Colors.black26,
                  progressColor: kPrimaryColor,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class NoUnpaid extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoUnpaid({
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
            'images/imgs/file.png',
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'No outstanding bill found at the moment.',
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