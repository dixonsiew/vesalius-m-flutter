import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/doctor_model.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/doctor/doctor_bookmark.dart';

class Doctor extends StatefulWidget {

  static const String routeName = '/Doctor';

  final String? keyword;

  const Doctor({
    Key? key, 
    this.keyword,
  }) : super(key: key);

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
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    scr.addListener(() {
      if (scr.position.pixels == scr.position.maxScrollExtent) {
        loadMore();
      }
    });
    String s = widget.keyword != null ? widget.keyword! : '';
    searchController.text = s;
    setState(() {
      keyword = s;
    });
    load();
  }

  @override
  void dispose() {
    searchController.dispose();
    scr.removeListener(() {});
    scr.dispose();
    super.dispose();
  }

  void load() async {
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
    } on DioError catch (error) {
      setState(() {
        isLoading = false;
      });
      handleError(error, load);
    }
  }

  void loadMore() async {
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
    } on DioError catch (error) {
      setState(() {
        isLoading = false;
      });
      handleError(error, loadMore);
    }
  }

  Future<List<DoctorInfo>> getDoctors(num page) async {
    List<DoctorInfo> lx = [];
    var branchDetails = DataManager.branchDetails;
    if (!isSearch) {
      lx = await getAllDoctors(
          branchDetails!.branch!.branchId!, page, kPageSize);
    } else {
      lx = await searchDoctors(
          branchDetails!.branch!.branchId!, page, kPageSize, keyword);
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

  Future<void> toggleBookmark(
      bool isBookmarked, String mcr, DoctorInfo o) async {
    String userMode = await getUserMode();
    if (!isBookmarked) {
      await StorageDataManager.addDoctorBookmarkStorage(userMode, o);
      await getBookmarkedInfoIdFromStorage();
    } else {
      bool b = await showConfirmDialog(
          'Are you sure you want to delete this bookmark?');
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
    } else {
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

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: TextField(
        controller: searchController,
        autofocus: false,
        cursorColor: kMainColor,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          color: Color(0xFF002E50),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search By Speciality, Doctor Name",
          hintStyle: kBodyTextStyle.copyWith(
            color: const Color(0xFFB1B1B1),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 25.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: kMainColor,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 8.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(234, 234, 234, 0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(234, 234, 234, 0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        onSubmitted: (String s) {
          searchDoctor(s);
        },
      ),
    );
  }

  Widget buildContent(DoctorInfo o) {
    String mcr = o.mcr!;
    bool isBookmarked = checkBookmarkedMcr(mcr);

    return DoctorItem(
      data: o,
      isBookmarked: isBookmarked,
      onToggleBookmark: toggleBookmark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Search Doctor',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                final ctx = context.read<DoctorModel>();
                await Get.toNamed(DoctorBookmark.routeName);
                bool b = ctx.isbookmarkChanged;
                if (b) {
                  ctx.setBookmarkChanged(false);
                  await getBookmarkedInfoIdFromStorage();
                }
              },
              icon: const Icon(
                Icons.bookmark_sharp,
                color: kMainColor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator:
            const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: onRefresh,
            color: kMainColor,
            child: Scrollbar(
              child: ListView.builder(
                controller: scr,
                shrinkWrap: true,
                itemCount: list.length + 2,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return buildSearch();
                  } else if (i == 1) {
                    return const SizedBox(height: 20.0);
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
