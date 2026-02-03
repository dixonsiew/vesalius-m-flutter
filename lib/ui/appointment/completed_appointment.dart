import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/components/package_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/completed_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class CompletedAppointment extends StatefulWidget {

  const CompletedAppointment({super.key});

  @override
  State<CompletedAppointment> createState() => _CompletedAppointmentState();
}

class _CompletedAppointmentState extends State<CompletedAppointment> with AutomaticKeepAliveClientMixin<CompletedAppointment> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final CompletedAppointmentCtrl ctrl = Get.put(CompletedAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      await ctrl.load();
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoAppointment(onRefresh: onRefresh);
    }

    return Scrollbar(
      child: Obx(() => 
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: ctrl.list.length,
            itemBuilder: (context, i) {
              final o = ctrl.list[i];
              return CompletedAppointmentItem(
                key: UniqueKey(),
                data: o,
              );
            },
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        blur: kBlur,
        progressIndicator: const AppActivityIndicator(),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: buildContent(),
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => false;
}

class CompletedAppointmentItem extends StatelessWidget {

  final PastAppointment data;

  const CompletedAppointmentItem({
    super.key,
    required this.data,
  });

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  String get apptTime {
    String s = '${getDate(data.appointmentDate)}, ${getTime(data.appointmentTime)}';
    if (data.apptSlotType == 'Session') {
      String a = getTime(data.sessionStartTime!);
      String b = getTime(data.sessionEndTime!);
      s = '${getDate(data.appointmentDate)}, ${data.apptSessionType} ($a-$b)';
    }

    return s;
  }

  List<Widget> buildDoctorContent() {
    List<DoctorSpecialities>? specialtyList = data.doctorSpecialities;
    List<DoctorClinicLocation>? locationList = data.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${data.name}'.trim().capitalize ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor4,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].toString(),
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([w, const SizedBox(height: 8.0)]);
    }

    if (locationList.isNotEmpty) {
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location1.png',
            width: 10.0,
            height: 10.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            locationList.first.location ?? '',
            style: kTextStyle1.copyWith(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: kTextColor4,
            ),
          ),
        ],
      );
      ls.add(l);
    }

    else {
      ls.removeLast();
    }

    return ls;
  }

  Widget buildPackageItem() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: PackageImage(
            img: data.apptPackageImage,
            width: 90.0,
            height: 90.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.apptPackagePurchaseNo ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor4,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                data.apptPackageName ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDoctorItem() {
    List<DoctorContact> contactList = data.doctorContact;
    final List<DoctorContact> lc = contactList.where((x) => x.contactType == 'Contact No').toList();
    final contact = lc.isEmpty ? null : lc.first;

    return Row(
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(32.0),
            child: DoctorImage(img: data.image),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildDoctorContent(),
          ),
        ),
        if (contact != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: () {
                makePhoneCall(contact);
              },
              splashRadius: 22.0,
              icon: Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.call,
                    color: kPrimaryColor,
                    size: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kColor1.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 4.0),
            color: kBgColor2.withValues(alpha: 0.1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: kSecondaryColor2,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/clock5.png',
                            width: 10.0,
                            height: 10.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 4.0),
                          Flexible(
                            child: Text(
                              apptTime,
                              //'12 Dec, 3:30 PM',
                              style: kTextStyle1.copyWith(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: kSecondaryColor2,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/user.png',
                            width: 10.0,
                            height: 10.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 4.0),
                          Flexible(
                            child: Text(
                              data.apptPatientName ?? '',
                              style: kTextStyle1.copyWith(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              if (data.apptPackagePurchaseNo != null) ...[
                buildPackageItem(),
              ] else ...[
                buildDoctorItem(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NoAppointment extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoAppointment({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/medical-record.png',
            width: 73.61,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'You do not have any completed appointment at the moment.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}