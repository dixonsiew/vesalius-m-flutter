import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/content.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_bookmark_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_data_manager.dart';

class DoctorBookmark extends StatefulWidget {

  const DoctorBookmark({super.key});

  @override
  State<DoctorBookmark> createState() => _DoctorBookmarkState();
}

class _DoctorBookmarkState extends State<DoctorBookmark> {

  late final TextEditingController txtsearch;

  final DoctorCtrl doctorCtrl = Get.put(DoctorCtrl());
  final DoctorBookmarkCtrl ctrl = Get.put(DoctorBookmarkCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtsearch.dispose();
    super.dispose();
  }

  void load() async {
    ctrl.setIsLoading(true);
    await AuthManager.instance.load();
    await getDoctorFromStorage();
    ctrl.setIsLoading(false);
  }

  Future<void> onToggleBookmark(bool isBookmarked, String mcr, DoctorInfo o) async {
    String? userMode = await AuthManager.instance.getUserMode();
    if (!isBookmarked) {
      await UserDataManager.instance.addDoctorBookmark(userMode, o);
      //await StorageDataManager.addDoctorBookmarkStorage(userMode, o);
      await getDoctorFromStorage();
      await getBookmarkedInfoIdFromStorage();
    }
    
    else {
      bool b = await showConfirmDialog('Are you sure you want to delete this bookmark?');
      if (b) {
        await UserDataManager.instance.removeDoctorBookmark(userMode, mcr);
        //await StorageDataManager.delDoctorInformationFromStorage(userMode, mcr);
        await getDoctorFromStorage();
        await getBookmarkedInfoIdFromStorage();
      }
    }
  }

  Future<void> getBookmarkedInfoIdFromStorage() async {
    String userMode = await AuthManager.instance.getUserMode();
    final res = await UserDataManager.instance.getDoctorBookmarkMCRList(userMode);
    //final res = await StorageDataManager.getInfoIdFromStorage(userMode, 'doctor');
    doctorCtrl.setBookmarkedInfoId(res);
  }

  Future<void> getDoctorFromStorage() async {
    String? userMode = await AuthManager.instance.getUserMode();
    final res = await UserDataManager.instance.getDoctorBookmarkList(userMode);
    //List<DoctorInfo> res = await StorageDataManager.getDoctorDataStorage(userMode);
    ctrl.init();
    ctrl.setList(res);
  }

  void filterDoctor(String s) {
    if (s.isEmpty) {
      ctrl.resetList();
    }

    else {
      String r = s.toLowerCase();
      final q = ctrl.mlist.where((o) {
        String name = o.name ?? '';
        bool bname = name.toLowerCase().contains(r);
        List<DoctorSpecialities> specialtyList = o.doctorSpecialities;
        bool bspecialtyList = false;
        if (specialtyList.isNotEmpty) {
          final ls = specialtyList.map((e) {
            String x = e.specialities ?? '';
            return x;
          });
          String x = ls.join(', ');
          bspecialtyList = x.toLowerCase().contains(r);
        }

        return bname || bspecialtyList;
      });
      ctrl.setFilteredList(q.toList());
    }
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kColor6.withValues(alpha: 0.21),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: txtsearch,
        autofocus: false,
        cursorColor: kPrimaryColor,
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
            borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
          ),
        ),
        onChanged: filterDoctor,
      ),
    );
  }

  Widget buildContent(DoctorInfo data) {
    return DoctorItem(
      key: ValueKey(data.doctorId),
      data: data,
      onToggleBookmark: onToggleBookmark,
    );
  }

  Widget buildList() {
    return Obx(() =>
      ListView.builder(
        shrinkWrap: true,
        itemCount: ctrl.list.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return buildSearch();
          }
    
          return buildContent(ctrl.list[i - 1]);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Bookmark',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: Scrollbar(
              child: buildList(),
            ),
          ),
        ),
      ),
    );
  }
}