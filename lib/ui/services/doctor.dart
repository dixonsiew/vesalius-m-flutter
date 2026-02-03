import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/content.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/guest_service.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/ui/services/doctor/doctor_bookmark.dart';

class Doctor extends StatefulWidget {

  final String? keyword;

  const Doctor({
    super.key,
    this.keyword,
  });

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {

  ScrollController scr = ScrollController();
  late final TextEditingController txtsearch;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final DoctorCtrl ctrl = Get.put(DoctorCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    scr.addListener(scrollListener);
    String s = widget.keyword != null ? widget.keyword! : '';
    txtsearch.text = s;
    ctrl.setKeyword(s);
    load();
  }

  @override
  void dispose() {
    txtsearch.dispose();
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
      await AuthManager.instance.load();
      await getBookmarkedInfoIdFromStorage();
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
      await getBookmarkedInfoIdFromStorage();
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
    num branchId = branchDetails == null ? 1 : branchDetails.branch?.branchId ?? 1;
    if (!isSearch) {
      if (AuthManager.instance.isLogin) {
        lx = await PublicVesaliusService.getAllDoctors(branchId, page, kPageSize);
      }

      else {
        lx = await GuestModeService.getAllDoctors(branchId, page, kPageSize);
      }
    }
    
    else {
      if (AuthManager.instance.isLogin) {
        lx = await PublicVesaliusService.searchDoctors(branchId, page, kPageSize, ctrl.keyword);
      }

      else {
        lx = await GuestModeService.searchDoctors(branchId, page, kPageSize, ctrl.keyword);
      }
    }

    return lx;
  }

  bool get isSearch {
    return ctrl.keyword != '';
  }

  Future<void> onRefresh() async {
    load();
  }

  Future<void> onToggleBookmark(bool isBookmarked, String mcr, DoctorInfo o) async {
    String userMode = await AuthManager.instance.getUserMode();
    if (!isBookmarked) {
      await UserDataManager.instance.addDoctorBookmark(userMode, o);
      //await StorageDataManager.addDoctorBookmarkStorage(userMode, o);
      await getBookmarkedInfoIdFromStorage();
    }
    
    else {
      bool b = await showConfirmDialog('Are you sure you want to delete this bookmark?');
      if (b) {
        await UserDataManager.instance.removeDoctorBookmark(userMode, mcr);
        //await StorageDataManager.delDoctorInformationFromStorage(userMode, mcr);
        await getBookmarkedInfoIdFromStorage();
      }
    }
  }

  Future<void> getBookmarkedInfoIdFromStorage() async {
    String userMode = await AuthManager.instance.getUserMode();
    final res = await UserDataManager.instance.getDoctorBookmarkMCRList(userMode);
    //final res = await StorageDataManager.getInfoIdFromStorage(userMode, 'doctor');
    ctrl.setBookmarkedInfoId(res);
  }

  void onSearchDoctor(String s) {
    ctrl.setKeyword(s);
    load();
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEAEAEA).withValues(alpha: 0.21),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: txtsearch,
        autofocus: false,
        cursorColor: kPrimaryColor,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search By Speciality, Doctor Name',
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor5,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.35)),
          ),
        ),
        onSubmitted: onSearchDoctor,
      ),
    );
  }

  Widget buildContent(DoctorInfo o) {
    return DoctorItem(
      key: ValueKey(o.doctorId),
      data: o,
      onToggleBookmark: onToggleBookmark,
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
          return buildSearch();
        }
        
        else if (i == ctrl.list.length + 1) {
          return Obx(() => ctrl.isLoadingMore ? const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: AppLoadMoreIndicator(),
          ) : Container());
        }
        
        return buildContent(ctrl.list[i - 1]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Search Doctor',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: () {
              Get.to(() => const DoctorBookmark());
            },
            icon: const Icon(
              Icons.bookmark_sharp,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
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
              child: Scrollbar(
                controller: scr,
                child: buildList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
