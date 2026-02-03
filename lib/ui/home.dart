import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_manager.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/medical_history_auth.dart';
import 'package:vesalius_m_flutter/ui/hospital.dart';

import 'allergies.dart';
import 'appointment/appointment_detail.dart';
import 'doctor.dart';
import 'health_dashboard.dart';
import 'hospital/our_story.dart';
import 'package.dart';
import 'patient_survey.dart';
import 'visit_history.dart';

class Home extends StatefulWidget {

  static const String routeName = '/Home';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {

  bool isLoading = false;
  bool isSearch = false;
  bool isAuth = false;
  PatientDetails? patientDetails;
  FutureAppointment? appointment;
  UserBranch? branch;
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
    setState(() {
      isLoading = true;
    });
    AppointmentManager.start(context);
    await AuthManager.load();
    await DataManager.getUserDetails();
    PatientDetails? x = await DataManager.getPatientDetails();
    UserBranch? branchDetails = await DataManager.getBranchDetails();
    if (branchDetails != null && branchDetails.branch != null && AuthManager.isLogin) {
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
    }

    setState(() {
      isAuth = AuthManager.isLogin;
      patientDetails = x;
      isLoading = false;
    });
  }

  String get name {
    Name? x = patientDetails!.name;
    String s = '${x?.title} ${x?.firstName} ${x?.middleName} ${x?.lastName}'.trim();
    return s;
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

    return '$s $b ,';
  }

  String getTime(String s) {
    List<String> a = s.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  String getAppointmentSchedule() {
    FutureAppointment? appmt = Provider.of<AppointmentModel>(context).appointment;
    return '${getDate(appmt!.date!)}, ${getTime(appmt.startTime!)}';
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

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 15.0),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: kMainColor,
              ),
              onPressed: () {
                Get.to(() => Doctor(keyword: searchController.text));
              },
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
    if (isLoading) {
      return Container();
    }

    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 14.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greetings,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                        ),
                      ),
                      Text(
                        name,
                        style: kTextStyle1.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'images/imgs/bell.png',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          buildSearch(),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Upcoming Appointment',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: kMainColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEBEBEB).withOpacity(0.7),
                    blurRadius: 7.0,
                  ),
                ],
              ),
              child: Material(
                color: kMainColor,
                borderRadius: BorderRadius.circular(5.0),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppointmentDetail.routeName);
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 16.0),
                            Image.asset(
                              'images/imgs/pic.png',
                              width: 48.0,
                              height: 48.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TAN SRI DATO' DR. YAHYA AWANG",
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Consultant Cardiothoracic Surgeon',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              'images/icon/right.png',
                              width: 16.0,
                              height: 16.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'images/icon/clock.png',
                                    width: 14.0,
                                    height: 14.0,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    '03 Dec 2022, 8:30 AM',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                'Admission',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 200.0,
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  ServiceItem(
                    image: 'queue-tracker.png',
                    title: 'Queue\nTracker',
                    onTap: () {
                      
                    }
                  ),
                  ServiceItem(
                    image: 'inpatient-journey.png',
                    title: 'Inpatient\nJourney',
                    onTap: () {
                      
                    }
                  ),
                  ServiceItem(
                    image: 'medical-history.png',
                    title: 'Medical\nHistory',
                    onTap: () {
                      Get.toNamed(MedicalHistoryAuth.routeName);
                    }
                  ),
                  ServiceItem(
                    image: 'doctor-information.png',
                    title: 'Doctor\nInformation',
                    onTap: () {
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
                  ServiceItem(
                    image: 'prescription-request.png',
                    title: 'Prescription\nRequest',
                    onTap: () {

                    }
                  ),
                  ServiceItem(
                    image: 'feedback.png',
                    title: 'Feedback',
                    onTap: () {

                    }
                  ),
                  ServiceItem(
                    image: 'patient-edu.png',
                    title: 'Patient\nEducation',
                    onTap: () {

                    }
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Our Packages',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
                TextButton(
                  onPressed: () {

                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kMainColor,
                  ),
                  child: Text(
                    'See More',
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 148.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/imgs/pc1.png',
                          width: 148.0,
                          height: 148.0,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                          child: Text(
                            'Cardiac Health Screening Package',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 10.0),
                          child: Text(
                            'RM 1029.00',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: kMainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    width: 148.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/imgs/pc2.png',
                          width: 148.0,
                          height: 148.0,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                          child: Text(
                            'Blood Screening Package',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 10.0),
                          child: Text(
                            'RM 108.00',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: kMainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    width: 148.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/imgs/pc2.png',
                          width: 148.0,
                          height: 148.0,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                          child: Text(
                            'Blood Screening Package',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 10.0),
                          child: Text(
                            'RM 108.00',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: kMainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const AppActivityIndicator(),
      child: buildContent(),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class ServiceItem extends StatelessWidget {

  final String image;
  final String title;
  final void Function() onTap;

  const ServiceItem({
    Key? key,
    required this.image,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/$image',
            width: 48.0,
            height: 48.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5.0),
          Flexible(
            child: Text(
              title,
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                color: kTextColor4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}