import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/doctor/doctor_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_bookmark_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/doctor/doctor_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';
import 'package:vesalius_m_flutter/ui/appointment/patient_info.dart';
import 'package:vesalius_m_flutter/ui/appointment/select_patient.dart';
import 'package:vesalius_m_flutter/ui/services/doctor/doctor_detail.dart';

class DoctorItem extends StatelessWidget {

  final DoctorInfo data;
  final Future<void> Function(bool, String, DoctorInfo) onToggleBookmark;

  final DoctorCtrl ctrl = Get.put(DoctorCtrl());
  final DoctorBookmarkCtrl doctorBookmarkCtrl = Get.put(DoctorBookmarkCtrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());
  
  DoctorItem({
    super.key, 
    required this.data,
    required this.onToggleBookmark,
  });

  void onMakeAppointmentGuest() async {
    Get.to(() => PatientInfo(doctorInfo: data));
  }

  void onMakeAppointment() async {
    try {
      selectPatientCtrl.init();
      ctrl.setIsLoading(true);
      doctorBookmarkCtrl.setIsLoading(true);
      List<Family> lx = await MyFamilyService.getAllFamilies(1, kPageSize, true, true);
      ctrl.setIsLoading(false);
      doctorBookmarkCtrl.setIsLoading(false);
      selectPatientCtrl.setFamily(null);

      if (lx.length == 1) {
        selectPatientCtrl.setFamily(lx.first);
      }

      if (lx.length < 2) {
        selectPatientCtrl.setSelectPatient(false);
        Get.to(() => NewAppointment(doctorInfo: data));
      }

      else {
        selectPatientCtrl.setSelectPatient(true);
        Get.to(() => SelectPatient(doctorInfo: data, list: lx));
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      doctorBookmarkCtrl.setIsLoading(false);
      handleLoadError(error, onMakeAppointment);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      doctorBookmarkCtrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  List<Widget> buildDoctorContent(DoctorInfo o) {
    List<DoctorSpecialities> specialtyList = o.doctorSpecialities;
    List<DoctorClinicLocation> locationList = o.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${o.name}'.trim(),
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
      ls.addAll([w, const SizedBox(height: 5.0)]);
    }

    if (locationList.isNotEmpty) {
      String? building = locationList.first.building;
      String loc = locationList.first.location ?? '';
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location5.png',
            width: 10.0,
            height: 10.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8.0),
          if (building == null) ...[
            Text(
              locationList.first.toString(),
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: kTextColor4,
              ),
            ),
          ] else ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: building == 'Peel Wing' ? kPeelWingColor : kOthersColor,
                  ),
                ),
                Text(
                  loc,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor4,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
      ls.add(l);
    }

    else {
      ls.removeLast();
    }

    // final r = Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Image.asset(
    //       'images/imgs/star.png',
    //       width: 8.0,
    //       height: 7.67,
    //       fit: BoxFit.cover,
    //     ),
    //     SizedBox(width: 4.0),
    //     Text(
    //       '4.9 (120 Reviews)',
    //       style: kBodyTextStyle.copyWith(
    //         fontSize: 10.0,
    //         fontWeight: FontWeight.w600,
    //         color: Color(0xFF4E4E4E),
    //       ),
    //     ),
    //   ],
    // );
    //ls.add(r);

    return ls;
  }

  List<Widget> buildContents() {
    String mcr = data.mcr!;
    List<DoctorContact> contactList = data.doctorContact;
    final List<DoctorContact> lc = contactList.where((x) => x.contactType == 'Contact No').toList();
    final contact = lc.isEmpty ? null : lc.first;

    List<Widget> ls = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(32.0), // Image radius
                      child: DoctorImage(img: data.image),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: buildDoctorContent(data),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await onToggleBookmark.call(ctrl.hasBookmarkedInfoId(mcr), mcr, data);
            },
            splashRadius: 24.0,
            icon: Obx(() => 
              Icon(
                ctrl.hasBookmarkedInfoId(mcr) ? Icons.bookmark_sharp : Icons.bookmark_outline_sharp,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    ];

    final callBtn = OutlinedButton(
      onPressed: () {
        makePhoneCall(contact!);
      }, 
      style: OutlinedButton.styleFrom(
        foregroundColor: kPrimaryColor,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 32.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        side: const BorderSide(
          color: kPrimaryColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/call.png',
            width: 12.0,
            height: 12.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            'Call',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );

    final makeApptGuestBtn = ElevatedButton(
      onPressed: onMakeAppointmentGuest,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 32.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/calendar.png',
            width: 12.0,
            height: 12.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            'Make Appointment',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    final makeApptBtn = ElevatedButton(
      onPressed: onMakeAppointment,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 32.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/icon/calendar.png',
            width: 12.0,
            height: 12.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            'Make Appointment',
            style: kTextStyle1.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (AuthManager.instance.isLogin) {
      if (data.allowAppointment == 'Y') {
        if (contact != null) {
          final r = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: callBtn,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 2,
                child: makeApptBtn,
              ),
            ],
          );
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: r,
            ),
          );
        }

        else {
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: makeApptBtn,
            ),
          );
        }
      }

      else {
        if (contact != null) {
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: callBtn,
            ),
          );
        }
      }
    }

    else {
      if (data.showMakeAppointmentButton == 'Y') {
        if (contact != null) {
          final r = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: callBtn,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 2,
                child: makeApptGuestBtn,
              ),
            ],
          );
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: r,
            ),
          );
        }

        else {
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: makeApptGuestBtn,
            ),
          );
        }
      }

      else {
        if (contact != null) {
          ls.add(
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: callBtn,
            ),
          );
        }
      }
    }

    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kColor1.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: kColor1.withValues(alpha: 0.3),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            Get.to(() => DoctorDetail(mcr: data.mcr!));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildContents(),
            ),
          ),
        ),
      ),
    );
  }
}