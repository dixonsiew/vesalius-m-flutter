import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/upcoming_tests_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/future_order_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class UpcomingTests extends StatefulWidget {

  const UpcomingTests({super.key});

  @override
  State<UpcomingTests> createState() => _UpcomingTestsState();
}

class _UpcomingTestsState extends State<UpcomingTests> {

  ScrollController scr = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final UpcomingTestsCtrl ctrl = Get.put(UpcomingTestsCtrl());

  @override
  void initState() {
    super.initState();
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
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      List<FutureOrder> lx = await FutureOrderService.getAllFutureOrders(branchDetails!.prn!, ctrl.page, kPageSize);
      ctrl.setList(lx);
      ctrl.setIsLoading(false);
    }
    
    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
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
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      List<FutureOrder> lx = await FutureOrderService.getAllFutureOrders(branchDetails!.prn!, p, kPageSize);
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

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoUpcomingTests(onRefresh: onRefresh);
    }

    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Obx(() =>
          ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: ctrl.list.length + 1,
            itemBuilder: (context, i) {
              if (i == ctrl.list.length) {
                return Obx(() => ctrl.isLoadingMore ? const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: AppLoadMoreIndicator(),
                ) : Container());
              }

              return UpcomingTestsItem(
                key: UniqueKey(),
                data: ctrl.list[i],
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
      title: 'Upcoming Tests',
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

class UpcomingTestsItem extends StatelessWidget {

  final FutureOrder data;

  const UpcomingTestsItem({
    super.key,
    required this.data,
  });

  Widget buildDetailsItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(32.0),
            child:  Image.asset(
              'images/imgs/test.png',
              width: 48.0,
              height: 48.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Text(
                data.description,
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'Ordered Doctor:',
                    style: kTextStyle1.copyWith(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor4,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Expanded(
                    child: Text(
                      data.orderDoctor,
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: kColor3.withValues(alpha: 0.4),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: kSecondaryColor2,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/clock5.png',
                            width: 10.0,
                            height: 10.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              data.performDate,
                              style: kTextStyle1.copyWith(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: kSecondaryColor2,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/user.png',
                            width: 10.0,
                            height: 10.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 4.0),
                          Flexible(
                            child: Text(
                              data.patientName,
                              style: kTextStyle1.copyWith(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              buildDetailsItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class NoUpcomingTests extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoUpcomingTests({
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
            'images/imgs/medical-record.png',
            width: 73.61,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'There is no upcoming test available. Please check again the next day.',
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