import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart' as dx;
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/ui/health_package.dart';
import 'package:vesalius_m_flutter/ui/home/notification.dart';
import 'package:vesalius_m_flutter/ui/services/feedback.dart';
import 'package:vesalius_m_flutter/ui/services/hospital.dart';
import 'package:vesalius_m_flutter/ui/services/inpatient_journey.dart';
import 'package:vesalius_m_flutter/ui/services/my_family.dart';
import 'package:vesalius_m_flutter/ui/services/patient_education.dart';
import 'package:vesalius_m_flutter/ui/services/prescription_request.dart';
import 'package:vesalius_m_flutter/ui/services/queue_tracker.dart';

import 'appointment/appointment_detail.dart';
import 'services/doctor.dart';
import 'services/medical_history.dart';

class Home extends StatefulWidget {

  static const String routeName = '/Home';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>, SingleTickerProviderStateMixin {

  UserBranch? branch;
  late final TextEditingController txtsearch;
  late TabController tabController;

  final HomeCtrl ctrl = Get.put(HomeCtrl());
  final UpcomingAppointmentCtrl upcomingAppointmentCtrl = Get.put(UpcomingAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      ctrl.setCurrent(tabController.index);
    });
    load();
  }

  @override
  void dispose() {
    txtsearch.dispose();
    tabController.removeListener(() { });
    tabController.dispose();
    super.dispose();
  }

  void load() async {
    ctrl.setIsLoading(true);
    await AuthManager.load();
    await DataManager.getUserDetails();
    PatientDetails? x = await DataManager.getPatientDetails();
    UserBranch? branchDetails = await DataManager.getBranchDetails();
    if (branchDetails != null && branchDetails.branch != null && AuthManager.isLogin) {
      // await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
      await upcomingAppointmentCtrl.load();
      if (upcomingAppointmentCtrl.list.isNotEmpty) {
        ctrl.setAppointment(upcomingAppointmentCtrl.list.first);
      }

      else {
        ctrl.setAppointment(null);
      }
    }

    ctrl.setPatientDetails(x);
    ctrl.setIsLoading(false);
  }

  String get name {
    Name? x = ctrl.patientDetails!.name;
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

  // String getTime(String s) {
  //   List<String> a = s.split(':');
  //   int hour = int.parse(a[0]);
  //   int min = int.parse(a[1]);
  //   final now = DateTime.now();
  //   final dt = DateTime(now.year, now.month, now.day, hour, min);
  //   return formatDate(dt, [h, ':', nn, ' ', am]);
  // }

  // String getDate(String s) {
  //   return s.replaceAll('-', ' ');
  // }

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
    UserBranch? o = await Get.dialog(StatefulBuilder(
      builder: (context, setState) => CupertinoAlertDialog(
        title: const Text(
          'Select Hospital',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: kBodyFont,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
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
      )),
    );
    if (o != null) {
      await DataManager.setBranchDetails(o);
    }
  }

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  List<Widget> buildDoctorContent() {
    List<dx.DoctorSpecialities>? specialtyList = ctrl.appointment!.doctorSpecialities;

    List<Widget> ls = [
      Text(
        ctrl.appointment!.name?.trim() ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].specialities ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 8.0),
      ]);
    }

    ls.removeLast();
    return ls;
  }

  Image getDoctorImage() {
    String? image = ctrl.appointment!.image;
    Image im = Image.asset('images/imgs/no_image.png', fit: BoxFit.cover);
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    }

    return im;
  }

  Widget buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEAEAEA).withOpacity(0.21),
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
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search By Speciality, Doctor Name',
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor2,
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
            borderSide: BorderSide(color: const Color(0xFFEAEAEA).withOpacity(0.21)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: const Color(0xFFEAEAEA).withOpacity(0.21)),
          ),
        ),
        onSubmitted: (value) => Get.to(() => Doctor(keyword: value)),
      ),
    );
  }

  Widget buildContent() {
    return ctrl.isLoading ? Container() : 
    Scrollbar(
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
                IconButton(
                  onPressed:() {
                    Get.to(() => const NotificationX());
                  },
                  icon: Image.asset(
                    'images/imgs/bell.png',
                    width: 24.0,
                    height: 24.0,
                    fit: BoxFit.contain,
                  ),
                  padding: const EdgeInsets.all(2.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          buildSearch(),
          const SizedBox(height: 32.0),
          if (ctrl.appointment != null) ...[
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
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEBEBEB).withOpacity(0.7),
                      blurRadius: 7.0,
                    ),
                  ],
                ),
                child: Material(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(5.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const AppointmentDetail());
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
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(24.0),
                                  child: getDoctorImage(),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: buildDoctorContent(),
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
                                      '${getDate(ctrl.appointment!.apptDate)}, ${getTime(ctrl.appointment!.apptStartTime)}',
                                      //'03 Dec 2022, 8:30 AM',
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
            const SizedBox(height: 32.0),
          ],
          
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
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
              height: 190.0,
              child: DefaultTabController(
                length: 2,
                child: Builder(
                  builder: (context) => TabBarView(
                    controller: tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        clipBehavior: Clip.antiAlias,
                        crossAxisCount: 4,
                        children: [
                          ServiceItem(
                            image: 'queue-tracker.png',
                            title: 'Queue\nTracker',
                            onTap: () {
                              Get.to(() => const QueueTracker());
                            }
                          ),
                          ServiceItem(
                            image: 'inpatient-journey.png',
                            title: 'Inpatient\nJourney',
                            onTap: () {
                              Get.to(() => const InpatientJourney());
                            }
                          ),
                          ServiceItem(
                            image: 'medical-history.png',
                            title: 'Medical\nHistory',
                            onTap: () {
                              Get.to(() => const MedicalHistory());
                            }
                          ),
                          ServiceItem(
                            image: 'doctor-information.png',
                            title: 'Doctor\nInformation',
                            width: 28.0,
                            height: 27.91,
                            onTap: () {
                              Get.to(() => const Doctor());
                            }
                          ),
                          ServiceItem(
                            image: 'hospital-information.png',
                            title: 'Hospital\nInformation',
                            height: 23.92,
                            onTap: () {
                              Get.to(() => const Hospital());
                            }
                          ),
                          ServiceItem(
                            image: 'prescription-request.png',
                            title: 'Prescription\nRequest',
                            height: 23.93,
                            onTap: () {
                              Get.to(() => const PrescriptionRequest());
                            }
                          ),
                          ServiceItem(
                            image: 'family.png',
                            title: 'My\nFamily',
                            height: 24.0,
                            onTap: () {
                              Get.to(() => const MyFamily());
                            }
                          ),
                          ServiceItem(
                            image: 'feedback.png',
                            title: 'Feedback\n',
                            width: 28.0,
                            height: 27.91,
                            onTap: () {
                              Get.to(() => const FeedbackX());
                            }
                          ),
                        ],
                      ),
    
                      GridView.count(
                        shrinkWrap: true,
                        clipBehavior: Clip.antiAlias,
                        crossAxisCount: 4,
                        children: [
                          ServiceItem(
                            image: 'patient-education.png',
                            title: 'Patient\nEducation',
                            onTap: () {
                              Get.to(() => const PatientEducation());
                            }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() =>
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [0, 1].map((i) {
                if (ctrl.current == i) {
                  return Container(
                    width: 20.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  );
                }
          
                return Container(
                  width: 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDADADA),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
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
                    Get.to(() => const HealthPackage());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
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
                          'images/imgs/pck1.png',
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
                              color: kPrimaryColor,
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
                          'images/imgs/pck2.png',
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
                              color: kPrimaryColor,
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
                          'images/imgs/pck3.png',
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
                              color: kPrimaryColor,
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
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: buildContent(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class ServiceItem extends StatelessWidget {

  final String image;
  final String title;
  final double width;
  final double height;
  final void Function() onTap;

  const ServiceItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.width = 24.0,
    this.height = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: const BoxDecoration(
              color: kSecondaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'images/imgs/$image',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
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