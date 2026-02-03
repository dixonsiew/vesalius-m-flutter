import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'doctor.dart';
import 'home.dart';
import 'hospital.dart';
import 'hospital/our_story.dart';
import 'package.dart';
import 'patient_survey.dart';
import 'sign_up.dart';

class Guest extends StatefulWidget {
  
  static const String routeName = '/Guest';

  const Guest({Key? key}) : super(key: key);

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> {

  UserBranch? branch;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String get greetings {
    int h = DateTime.now().hour;
    String s = 'Good';
    String b = 'Night';
    if (h < 12) {
      b = 'Morning';
    }

    else if (h >= 12 && h < 17) {
      b = 'Afternoon';
    }

    else if (h >= 17 && h <= 19) {
      b = 'Evening';
    }

    return '$s $b';
  }

  Widget buildBranchItem(UserBranch o) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            o.branchName ?? '',
            style: TextStyle(
              color: branch?.branchName == o.branchName ? kPrimaryColor : Colors.black,
              fontSize: 16.0,
              fontFamily: kBodyFont,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        branch?.branchName == o.branchName ?
        const Icon(
          Icons.check,
          color: kPrimaryColor,
          size: 24.0,
        ) :
        const SizedBox(width: 24.0, height: 24.0),
      ],
    );
  }

  List<Widget> buildBranchList(List<UserBranch> lx, void Function(void Function()) setState) {
    List<Widget> ls = [];
    for (int i = 0; i < lx.length; i++) {
      Widget w;
      UserBranch o = lx[i];

      if (i == 0) {
        w = Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                branch = o;
              });
            },
            child: buildBranchItem(o),
          ),
        );
      }

      else {
        w = Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                branch = o;
              });
            },
            child: buildBranchItem(o),
          ),
        );
      }

      ls.add(w);
    }

    return ls;
  }

  Future<void> selectBranch(List<UserBranch> lx) async {
    UserBranch? o = await showCupertinoDialog(
      context: context, 
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: const Text(
            'Select Hospital',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: kBodyFont,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                width: double.infinity,
                height: 1.0,
                color: const Color(0xFFE0E0E0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildBranchList(lx, setState),
              ),
            ],
          ),
          actions: [
            CupertinoButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            CupertinoButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              onPressed: () => Get.back(result: branch),
            ),
          ],
        ),
      ),
    );
    if (o != null) {
      await DataManager.setBranchDetails(o);
    }
  }

  Future<bool> onWillPop() async {
    return await showConfirmDialog('Are you sure you want to exit ?');
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
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search By Speciality, Doctor Name",
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor2,
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
            borderSide: BorderSide(
              color: const Color(0xFFEAEAEA).withOpacity(0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFFEAEAEA).withOpacity(0.21),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 14.0),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  greetings,
                  style: kMainTextStyle.copyWith(
                    fontSize: 24.0,
                    color: kMainColor,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2E7EA),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 18.0),
                            Text(
                              'Sign Up Now!',
                              style: kMainTextStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: kMainColor,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Sign up an account to enjoy more features.',
                              style: kBodyTextStyle.copyWith(
                                fontSize: 12.0,
                                color: kMainColor,
                              ),
                            ),
                            const SizedBox(height: 18.0),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Image.asset(
                          'images/imgs/guest.png',
                          width: 118.0,
                          height: 73.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              buildSearch(),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 15.0),
                child: Text(
                  'Services',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  height: 200.0,
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: [
                      ServiceItem(
                        image: 'doctor-information.png',
                        title: 'Doctor\nInformation',
                        onTap: () async {
                          UserBranch? branch = DataManager.branchDetails;
                          if (branch == null) {
                            final lx = await getPublicBranchList();
                            if (lx.length > 1) {
                              await selectBranch(lx);
                            }

                            else {
                              await DataManager.setBranchDetails(lx[0]);
                            }
                          }
                          Get.toNamed(Doctor.routeName);
                        }
                      ),
                      ServiceItem(
                        image: 'hospital-information.png',
                        title: 'Hospital\nInformation',
                        onTap: () {
                          Get.toNamed(Hospital.routeName);
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(SignUp.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: kMainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    ),
                    child: Text(
                      'Sign Up',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already an existing user? ',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kMainColor,
                      ),
                      child: Text(
                        'Sign In',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
          toolbarHeight: 0.0,
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0.0,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: SafeArea(
          child: buildContent(),
        ),
      ),
    );
  }
}