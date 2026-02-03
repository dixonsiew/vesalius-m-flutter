import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
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
      await AuthManager.load();
      await ctrl.load();
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return const NoAppointment();
    }

    return Scrollbar(
      child: Obx(() => 
        ListView.builder(
          shrinkWrap: true,
          itemCount: ctrl.list.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return const SizedBox(height: 32.0);
            }
      
            return CompletedAppointmentItem(
              data: ctrl.list[i - 1],
            );
          },
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
  bool get wantKeepAlive => true;
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
    return formatDate(DateTime.parse(s).toLocal(), [dd, ' ', M]);
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
        specialtyList[i].specialities ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 8.0),
      ]);
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

  Image getDoctorImage() {
    String? image = data.image;
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


  Widget buildDoctorItem() {
    List<DoctorContact> contactList = data.doctorContact;
    final List<DoctorContact> lc = contactList.where((x) => x.contactType == 'Contact No').toList();
    final contact = lc.isEmpty ? null : lc.first;

    return Row(
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(32.0),
            child: getDoctorImage(),
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
                decoration: const BoxDecoration(
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
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4.0),
            color: kBgColor2.withOpacity(0.1),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1EDFF),
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
                        Text(
                          '${getDate(data.appointmentDate)}, ${getTime(data.appointmentTime)}',
                          //'12 Dec, 3:30 PM',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: kTextColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1EDFF),
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
                        Text(
                          'Self',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: kTextColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              buildDoctorItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class NoAppointment extends StatelessWidget {

  const NoAppointment({super.key});

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
        ],
      ),
    );
  }
}