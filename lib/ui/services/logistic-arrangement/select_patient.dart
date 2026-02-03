import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class SelectPatient extends StatefulWidget {

  final Family? selected;

  const SelectPatient({
    super.key,
    this.selected,
  });

  @override
  State<SelectPatient> createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {

  ScrollController scr = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final SelectPatientCtrl ctrl = Get.put(SelectPatientCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setData(widget.selected);
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
      List<Family> lx = await MyFamilyService.getAllFamilies(ctrl.page, kPageSize, false, true);
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
      List<Family> lx = await MyFamilyService.getAllFamilies(p, kPageSize, false, true);
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
      handleError(error, loadMore);
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
      return NoPatient(onRefresh: onRefresh);
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            controller: scr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'OK',
              onPressed: () {
                Get.back(result: ctrl.data);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildList() {
    return ListView.builder(
      controller: scr,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: ctrl.list.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) {
          return const SizedBox(height: 16.0);
        }

        else if (i == ctrl.list.length + 1) {
          return Obx(() => ctrl.isLoadingMore ? const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: AppLoadMoreIndicator(),
          ) : Container());
        }
        
        final o = ctrl.list[i - 1];
        return PatientItem(
          key: ValueKey(o.aufId),
          data: o,
          ctrl: ctrl,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Patient',
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

class PatientItem extends StatelessWidget {

  final Family data;
  final SelectPatientCtrl ctrl;

  const PatientItem({
    super.key,
    required this.data,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: ctrl.data?.aufId == data.aufId ? kTextColor1 : kColor1.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: kColor1.withValues(alpha: 0.3),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              ctrl.setData(data);
              ctrl.setDataName(data.fullname);
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor2,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        data.fullname.isEmpty ? '' : data.fullname[0].toUpperCase(),
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.fullname,
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          data.relationship ?? '',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => data.aufId == ctrl.data?.aufId ? 
                  const Icon(
                    Icons.check,
                    color: kPrimaryColor,
                  ) : const SizedBox(
                    width: 24.0,
                    height: 24.0,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoPatient extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoPatient({
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
            'images/imgs/family1.png',
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'You do not have any family member under your profile at the moment.',
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

class SelectPatientCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <Family>[].obs;
  final _data = Rx<Family?>(null);
  final _dataName = ''.obs;

  void init() {
    setPage(1);
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsLoadingMore(bool b) {
    _isLoadingMore.value = b;
  }

  void setPage(int i) {
    _page.value = i;
  }

  void setList(List<Family> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setData(Family? o) {
    _data.value = o;
  }

  void setDataName(String s) {
    _dataName.value = s;
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  List<Family> get list => [..._list];
  Family? get data => _data.value;
  String get dataName => _dataName.value;
}