import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/hospital/content.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/storage_data_manager.dart';

class HospitalBookmark extends StatefulWidget {

  static const String routeName = 'HospitalBookmark';

  const HospitalBookmark({super.key});

  @override
  State<HospitalBookmark> createState() => _HospitalBookmarkState();
}

class _HospitalBookmarkState extends State<HospitalBookmark> {

  List<Map> hospitalBookmarks = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    await getDoctorAndHospitalFromStorage();
  }

  Future<void> toggleBookmark(bool isBookmarked, String hospitalInformationId, Map m) async {
    final dlg = CustomDialog.of(context);
    if (!isBookmarked) {
      String userMode = await getUserMode();
      await StorageDataManager.addHospitalBookmarkStorage(userMode, m);
      await getDoctorAndHospitalFromStorage();
    }

    else {
      bool b = await dlg.showConfirmDialog('Delete Bookmark', 'Are you sure you want to delete this bookmark?', 'Cancel', 'Sure');
      if (b) {
        await StorageDataManager.delHospitalInformationFromStorage(hospitalInformationId);
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
    var res = await StorageDataManager.getHospitalDataStorage(userMode);
    setState(() {
      hospitalBookmarks = res;
    });
  }

  bool checkBookmarkedHospitalInfo(String hospitalInformationId) {
    bool b = false;

    if (hospitalBookmarks.isNotEmpty) {
      for (int i = 0; i < hospitalBookmarks.length; i++) {
        String infoId = '${hospitalBookmarks[i]['data']['hospitalInformationId']}';
        if (hospitalInformationId == infoId) {
          b = true;
          break;
        }
      }
    }

    return b;
  }

  Widget buildContent(Map data) {
    Map m = data['data'];
    String? image = m['image'];
    String content = m['content'];
    String hospitalInformationId = '${m['hospitalInformationId']}';
    String title = m['title'];
    bool isBookmarked = checkBookmarkedHospitalInfo(hospitalInformationId);

    int i = image == null ? -1 : image.indexOf('base64,');
    String s = '';
    if (i >= 0) {
      i = i + 7;
      s = image!.substring(i);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Stack(
          children: [
            BackgroundLayer(
              title: title, 
              content: content, 
              isBookmarked: isBookmarked, 
              image: s,
            ),
            FrontLayer(
              title: title, 
              content: content, 
              hospitalInformationId: hospitalInformationId, 
              data: m, 
              isBookmarked: isBookmarked, 
              onToggleBookmark: toggleBookmark,
            ),
          ],
        ),
      );
    }

    else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: FrontLayer(
          title: title, 
          content: content, 
          hospitalInformationId: hospitalInformationId, 
          data: m, 
          isBookmarked: isBookmarked, 
          onToggleBookmark: toggleBookmark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kSearchHospitalBgColor),
        backgroundColor: kSearchHospitalBgColor,
        toolbarHeight: kAppToolbarHeight,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: hospitalBookmarks.length,
            itemBuilder: (context, i) {
              return buildContent(hospitalBookmarks[i]);
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}