import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/logistic_arrangement_data.dart';
import 'package:vesalius_m_flutter/services/logistic_service.dart';

class SelectSlot extends StatefulWidget {

  final LogisticSlot? selected;
  final String arrDt;
  final String arrTx;
  final bool withCompanion;

  const SelectSlot({
    super.key,
    this.selected,
    required this.arrDt,
    required this.arrTx,
    required this.withCompanion,
  });

  @override
  State<SelectSlot> createState() => _SelectSlotState();
}

class _SelectSlotState extends State<SelectSlot> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final SelectSlotCtrl ctrl = Get.put(SelectSlotCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setSlot(widget.selected);
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final o = {
        'flightArrivalDate': widget.arrDt,
        'flightArrivalTime': widget.arrTx,
        'withCompanion': widget.withCompanion,
      };
      List<LogisticSlot> lx = await LogisticService.postLogisticSlots(o);
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

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    return Stack(
      children: [
        if (!ctrl.isLoading && ctrl.list.isEmpty) ...[
          NoSlot(onRefresh: onRefresh),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Scrollbar(
              child: Obx(() =>
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: ctrl.list.length,
                  itemBuilder: (context, i) {
                    final o = ctrl.list[i];
                    return ListTile(
                      onTap: () {
                        ctrl.setSlot(o);
                      },
                      leading: Text(
                        o.dayOfWeek,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                      title: Text(
                        '${o.pickUpDate} ${o.pickUpTime}',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                      trailing: Obx(() => o.dayOfWeek == ctrl.slot?.dayOfWeek && o.pickUpTime == ctrl.slot?.pickUpTime ?
                      const Icon(
                        Icons.check,
                        color: kPrimaryColor,
                      ) : const SizedBox(
                        width: 24.0,
                        height: 24.0,
                      )),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return Container(
                      height: 1.0,
                      color: const Color(0xFFDBDBDB),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'OK',
              onPressed: () {
                Get.back(result: ctrl.slot);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Slot',
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

class NoSlot extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoSlot({
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
              'No slot found at the moment.',
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

class SelectSlotCtrl extends GetxController {

  final _isLoading = false.obs;
  final _slot = Rx<LogisticSlot?>(null);
  final _list = <LogisticSlot>[].obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setSlot(LogisticSlot? o) {
    _slot.value = o;
  }

  void setList(List<LogisticSlot> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  bool get isLoading => _isLoading.value;
  LogisticSlot? get slot => _slot.value;
  List<LogisticSlot> get list => [..._list];
}