import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/doctor/content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/doctor_model.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';

class DoctorBookmark extends StatefulWidget {
  
  static const String routeName = '/DoctorBookmark';

  const DoctorBookmark({Key? key}) : super(key: key);

  @override
  State<DoctorBookmark> createState() => _DoctorBookmarkState();
}

class _DoctorBookmarkState extends State<DoctorBookmark> {

  List<DoctorInfo> doctorBookmarks = [];
  List<DoctorInfo> _doctorBookmarks = [];
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    load();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void load() async {
    await AuthManager.load();
    await getDoctorAndHospitalFromStorage();
  }

  Future<void> toggleBookmark(bool isBookmarked, String mcr, DoctorInfo o) async {
    final ctx = context.read<DoctorModel>();
    String? userMode = await getUserMode();
    ctx.setBookmarkChanged(true);
    if (!isBookmarked) {
      await StorageDataManager.addDoctorBookmarkStorage(userMode, o);
      await getDoctorAndHospitalFromStorage();
    }
    
    else {
      bool b = await showConfirmDialog('Are you sure you want to delete this bookmark?');
      if (b) {
        await StorageDataManager.delDoctorInformationFromStorage(userMode, mcr);
        await getDoctorAndHospitalFromStorage();
      }
    }
  }

  Future<String> getUserMode() async {
    String userMode;
    if (AuthManager.isLogin) {
      UserDetails? userDetails = await DataManager.getUserDetails();
      userMode = userDetails!.email!;
    }

    else {
      userMode = 'guest';
    }

    return userMode;
  }

  Future<void> getDoctorAndHospitalFromStorage() async {
    String? userMode = await getUserMode();
    List<DoctorInfo> res = await StorageDataManager.getDoctorDataStorage(userMode);
    setState(() {
      doctorBookmarks = res;
      _doctorBookmarks = doctorBookmarks;
    });
  }

  bool checkBookmarkedMcr(String? mcr) {
    bool b = false;

    if (doctorBookmarks.isNotEmpty) {
      for (int i = 0; i < doctorBookmarks.length; i++) {
        String? infoId = doctorBookmarks[i].mcr;
        if (mcr == infoId) {
          b = true;
          break;
        }
      }
    }

    return b;
  }

  void filterDoctor(String s) {
    if (s.isEmpty) {
      setState(() {
        doctorBookmarks = _doctorBookmarks;
      });
    }

    else {
      String r = s.toLowerCase();
      final q = _doctorBookmarks.where((o) {
        String name = o.name ?? '';
        bool bname = name.toLowerCase().contains(r);
        List<DoctorSpecialities>? specialtyList = o.doctorSpecialities;
        bool bspecialtyList = false;
        if (specialtyList != null) {
          final ls = specialtyList.map((e) {
            String x = e.specialities ?? '';
            return x;
          });
          String x = ls.join(', ');
          bspecialtyList = x.toLowerCase().contains(r);
        }

        return bname || bspecialtyList;
      });
      setState(() {
        doctorBookmarks = q.toList();
      });
    }
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
        onChanged: (String s) {
          filterDoctor(s);
        },
      ),
    );
  }

  Widget buildContent(DoctorInfo data) {
    String? mcr = data.mcr;
    bool isBookmarked = checkBookmarkedMcr(mcr);
    return DoctorItem(
      data: data,
      isBookmarked: isBookmarked,
      onToggleBookmark: toggleBookmark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: kBgColor1,
        leading: const BackBtn(color: kTextColor1),
        centerTitle: true,
        title: Text(
          'Bookmark',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: kBgColor1,
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: doctorBookmarks.length + 2,
            itemBuilder: (context, i) {
              if (i == 0) {
                return buildSearch();
              }

              else if (i == 1) {
                return const SizedBox(height: 20.0);
              }

              return buildContent(doctorBookmarks[i - 2]);
            },
          ),
        ),
      ),
    );
  }
}