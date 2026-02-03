import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/doctor/content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/doctor-data.dart';
import 'package:vesalius_m_flutter/models/doctor-model.dart';
import 'package:vesalius_m_flutter/models/storage-data-manager.dart';

class DoctorBookmark extends StatefulWidget {
  
  static const String routeName = 'DoctorBookmark';

  @override
  _DoctorBookmarkState createState() => _DoctorBookmarkState();
}

class _DoctorBookmarkState extends State<DoctorBookmark> {

  List<DoctorInfo> doctorBookmarks = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    await getDoctorAndHospitalFromStorage();
  }

  Future<void> toggleBookmark(bool isBookmarked, String mcr, DoctorInfo o) async {
    String userMode = await getUserMode();
    context.read<DoctorModel>().setBookmarkChanged(true);
    if (!isBookmarked) {
      await StorageDataManager.addDoctorBookmarkStorage(userMode, o);
      await getDoctorAndHospitalFromStorage();
    }
    
    else {
      bool b = await showConfirmDialog('Delete Bookmark', 'Are you sure you want to delete this bookmark?', 'Cancel', 'Sure', context);
      if (b) {
        await StorageDataManager.delDoctorInformationFromStorage(userMode, mcr);
        await getDoctorAndHospitalFromStorage();
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

  Future<void> getDoctorAndHospitalFromStorage() async {
    String userMode = await getUserMode();
    var res = await StorageDataManager.getDoctorDataStorage(userMode);
    setState(() {
      doctorBookmarks = res;
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
        // brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kSearchDoctorBgColor),
        backgroundColor: kSearchDoctorBgColor,
        toolbarHeight: kAppToolbarHeight,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: doctorBookmarks.length,
            itemBuilder: (context, i) {
              return buildContent(doctorBookmarks[i]);
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}