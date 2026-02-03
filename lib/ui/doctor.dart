import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/doctor/doctor_bookmark.dart';

class Doctor extends StatefulWidget {
  
  static const String routeName = 'Doctor';

  const Doctor({super.key});

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {

  List<DoctorInfo> list = [];
  List<DoctorInfo> _list = [];
  List<Map> bookmarkedInfoId = [];
  ScrollController scr = ScrollController();
  int page = 1;
  String keyword = '';
  bool isLoading = false;

  final searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    scr.addListener(() {
      if (scr.position.pixels == scr.position.maxScrollExtent) {
        loadMore();
      }
    });
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    final dlg = CustomDialog.of(context);
    await AuthManager.load();
    try {
      setState(() {
        isLoading = true;
      });
      await getBookmarkedInfoIdFromStorage();
      var lx = await getDoctors(page);
      setState(() {
        list = lx;
        page = 1;
        isLoading = false;
      });
    }

    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.handleError(error, load);
    }
  }

  void loadMore() async {
    final dlg = CustomDialog.of(context);
    int p = page + 1;
    try {
      setState(() {
        isLoading = true;
      });
      await getBookmarkedInfoIdFromStorage();
      var lx = await getDoctors(p);
      if (lx.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        list.addAll(lx);
        page = p;
        isLoading = false;
      });
    }

    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.handleError(error, loadMore);
    }
  }

  Future<List<DoctorInfo>> getDoctors(num page) async {
    List<DoctorInfo> lx = [];
    var branchDetails = DataManager.branchDetails;
    if (!isSearch) {
      lx = await getAllDoctors(branchDetails!.branch!.branchId!, page, kPageSize);
    }

    else {
      lx = await searchDoctors(branchDetails!.branch!.branchId!, page, kPageSize, keyword);
    }

    return lx;
  }

  bool get isSearch {
    return keyword != '';
  }

  Future<void> onRefresh() async {
    setState(() {
      page = 1;
      list.clear();
      _list.clear();
    });
    load();
  }

  Future<void> toggleBookmark(bool isBookmarked, String mcr, DoctorInfo o) async {
    final dlg = CustomDialog.of(context);
    String userMode = await getUserMode();
    if (!isBookmarked) {
      await StorageDataManager.addDoctorBookmarkStorage(userMode, o);
      await getBookmarkedInfoIdFromStorage();
    }
    
    else {
      bool b = await dlg.showConfirmDialog('Delete Bookmark', 'Are you sure you want to delete this bookmark?', 'Cancel', 'Sure');
      if (b) {
        await StorageDataManager.delDoctorInformationFromStorage(userMode, mcr);
        await getBookmarkedInfoIdFromStorage();
      }
    }
  }

  Future<String> getUserMode() async {
    String userMode;
    if (AuthManager.isLogin) {
      var userDetails = await DataManager.getUserDetails();
      userMode = userDetails!.email!;
    }

    else {
      userMode = 'guest';
    }

    return userMode;
  }

  Future<void> getBookmarkedInfoIdFromStorage() async {
    String userMode = await getUserMode();
    var res = await StorageDataManager.getInfoIdFromStorage(userMode, 'doctor');
    setState(() {
      bookmarkedInfoId = res;
    });
  }

  bool checkBookmarkedMcr(String mcr) {
    bool b = false;

    if (bookmarkedInfoId.isNotEmpty) {
      for (int i = 0; i < bookmarkedInfoId.length; i++) {
        if (mcr == bookmarkedInfoId[i]['infoId']) {
          b = true;
          break;
        }
      }
    }

    return b;
  }

  void searchDoctor(String s) {
    setState(() {
      keyword = s;
      page = 1;
      list.clear();
    });
    load();
  }

  /* void __filterDoctor(String s) {
    // ignore: null_aware_in_condition
    if (s?.isEmpty) {
      setState(() {
        list = _list;
      });
    }

    else {
      String r = s.toLowerCase();
      var q = _list.where((o) {
        String name = o.name;
        bool bname = name?.toLowerCase()?.contains(r);
        List<DoctorSpecialities> specialtyList = o.doctorSpecialities;
        bool bspecialtyList = false;
        if (specialtyList != null) {
          var ls = specialtyList.map((e) {
            String x = e.specialities;
            return x;
          });
          String x = ls.join(', ');
          bspecialtyList = x.toLowerCase().contains(r);
        }

        return bname || bspecialtyList;
      });
      setState(() {
        list = q.toList();
      });
    }
  } */

  Widget buildContent(DoctorInfo o) {
    String mcr = o.mcr!;
    bool isBookmarked = checkBookmarkedMcr(mcr);

    return DoctorItem(
      data: o,
      isBookmarked: isBookmarked,
      onToggleBookmark: toggleBookmark,
    );
  }

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: TextField(
          controller: searchController,
          cursorColor: const Color(0xFF999494),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
            hintText: 'Search',
            hintStyle: TextStyle(
              fontFamily: kBodyFont,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF999494),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xFF999494)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xFF999494)),
            ),
          ),
          onSubmitted: searchDoctor,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      height: 90.0,
      color: kSearchDoctorBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset(
              'images/icon/page-header-icon/search-doctor.png',
              width: 65.0,
              height: 50.0,
              fit: BoxFit.contain,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20.0, top: 40.0),
            child: Text(
              'Search Doctor Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: kTitleFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kSearchDoctorBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kSearchDoctorBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(DoctorBookmark.routeName);
              },
              icon: const Icon(
                Icons.bookmark_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: onRefresh,
            color: kPrimaryColor,
            child: Scrollbar(
              child: ListView.builder(
                controller: scr,
                shrinkWrap: true,
                itemCount: list.length + 2,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return buildHeader();
                  }

                  else if (i == 1) {
                    return buildSearch();
                  }

                  return buildContent(list[i - 2]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}