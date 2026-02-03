import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';

class SelectDoctor extends StatefulWidget {

  final String? selected;

  const SelectDoctor({
    super.key,
    this.selected,
  });

  @override
  State<SelectDoctor> createState() => _SelectDoctorState();
}

class _SelectDoctorState extends State<SelectDoctor> {

  ScrollController scr = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final SelectDoctorCtrl ctrl = Get.put(SelectDoctorCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setData(widget.selected ?? '');
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
      List<DoctorInfo> lx = await getDoctors(ctrl.page);
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
      // await Future.delayed(const Duration(seconds: 5));
      List<DoctorInfo> lx = await getDoctors(p);
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

  Future<List<DoctorInfo>> getDoctors(num page) async {
    List<DoctorInfo> lx = [];
    UserBranch? branchDetails = DataManager.instance.branchDetails;
    if (!isSearch) {
      lx = await PublicVesaliusService.getAllDoctors(branchDetails!.branch!.branchId!, page, kPageSize);
    }
    
    else {
      lx = await PublicVesaliusService.searchDoctors(branchDetails!.branch!.branchId!, page, kPageSize, '');
    }

    return lx;
  }

  bool get isSearch {
    return false;
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildDoctorContent(DoctorInfo o) {
    return DoctorItem(
      key: ValueKey(o.doctorId),
      data: o,
      ctrl: ctrl,
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            controller: scr,
            child: buildList(),
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
        
        return buildDoctorContent(ctrl.list[i - 1]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Doctor',
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

class DoctorItem extends StatelessWidget {

  final DoctorInfo data;
  final SelectDoctorCtrl ctrl;

  const DoctorItem({
    super.key,
    required this.data,
    required this.ctrl,
  });

  List<Widget> buildDoctorContent(DoctorInfo o) {
    List<DoctorSpecialities> specialtyList = o.doctorSpecialities;
    List<DoctorClinicLocation> locationList = o.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${o.name}'.trim(),
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor4,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].toString(),
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([w, const SizedBox(height: 5.0)]);
    }

    if (locationList.isNotEmpty) {
      String? building = locationList.first.building;
      String loc = locationList.first.location ?? '';
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location5.png',
            width: 10.0,
            height: 10.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8.0),
          if (building == null) ...[
            Text(
              locationList.first.toString(),
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: kTextColor4,
              ),
            ),
          ] else ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: building == 'Peel Wing' ? kPeelWingColor : kOthersColor,
                  ),
                ),
                Text(
                  loc,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor4,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
      ls.add(l);
    }

    else {
      ls.removeLast();
    }

    return ls;
  }

  Widget buildContents() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(32.0), // Image radius
                    child: DoctorImage(img: data.image),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: buildDoctorContent(data),
                  ),
                ),
              ),
              Obx(() => data.mcr == ctrl.data ? 
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            ctrl.setData(data.mcr!);
            ctrl.setDataName(data.name ?? '');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: buildContents(),
          ),
        ),
      ),
    );
  }
}

class SelectDoctorCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _page = 1.obs;
  final _list = <DoctorInfo>[].obs;
  final _data = ''.obs;
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

  void setList(List<DoctorInfo> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setData(String s) {
    _data.value = s;
  }

  void setDataName(String s) {
    _dataName.value = s;
  }

  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get page => _page.value;
  List<DoctorInfo> get list => [..._list];
  String get data => _data.value;
  String get dataName => _dataName.value;
}