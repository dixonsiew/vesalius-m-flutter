import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_3_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

import 'confirm_appointment.dart';
import 'new_appointment_4.dart';

class NewAppointment3 extends StatefulWidget {
  
  final DoctorInfo doctorInfo;
  final DoctorAppointmentStatus doctorAppointmentStatus;
  final bool isEdit;

  const NewAppointment3({
    super.key,
    required this.doctorInfo,
    required this.doctorAppointmentStatus,
    this.isEdit = false,
  });

  @override
  State<NewAppointment3> createState() => _NewAppointment3State();
}

class _NewAppointment3State extends State<NewAppointment3> {

  final NewAppointment3Ctrl ctrl = Get.put(NewAppointment3Ctrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());
  final NewAppointment2Ctrl newAppointment2Ctrl = Get.put(NewAppointment2Ctrl());
  final SelectPatientCtrl selectPatientCtrl = Get.put(SelectPatientCtrl());

  bool filterDate(AvailableSlot x) {
    final formatDatex = DateFormat('d-MMM-y');
    final startDate = formatDatex.format(newAppointment2Ctrl.date!);
    final s = formatDate(newAppointment2Ctrl.date!, [yyyy, '-', mm, '-', dd]);
    final v = '${s}T${ctrl.appointmentSession!.endTime}:00';
    final sessionEndTime = DateTime.parse(v);
    final t = '${s}T${x.endTime}:00';
    final slotStartTime = DateTime.parse(t);

    return x.date == startDate && slotStartTime.compareTo(sessionEndTime) <= 0;
  }

  void onNext() async {
    final formatDatex = DateFormat('dd-MMM-y');
    String? selectedSpecialtyCode = '';
    final startDate = formatDatex.format(newAppointment2Ctrl.date!);
    final doc = widget.doctorInfo;
    final doctorSpecialty = doc.doctorSpecialty;
    final specialtyCode = doctorSpecialty.isEmpty ? null : doctorSpecialty.firstWhereOrNull((x) => x.primarySpecialty == true)?.specialty?.specialtyCode;
    if (specialtyCode != null) {
      selectedSpecialtyCode = specialtyCode;
    }

    else {
      await showCustomDialog('Error', 'No specialty found on this doctor', 'Dismiss');
      return;
    }

    if (ctrl.appointmentSessionList.isEmpty) {
      ctrl.setDate(ctrl.xdate);
      final startTime = formatDate(ctrl.date!, [HH, ':', nn]);

      try {
        final o = {
          'caseType': newAppointmentCtrl.caseTypeCode,
          'mcr': doc.mcr,
          'specialtyCode': selectedSpecialtyCode,
          'startDate': startDate,
          'startTime': startTime
        };
        ctrl.setIsLoading(true);
        List<AvailableSlot> lx = [];
        if (AuthManager.instance.isLogin) {
          final branchDetails = DataManager.instance.branchDetails!;
          lx = await VesaliusService.getVesaliusNextAvailableSlot(branchDetails.branch!.branchId!, selectPatientCtrl.family?.prn ?? branchDetails.prn!, o);
        }

        else {
          String prn = newAppointmentCtrl.patient?.prn ?? '';
          lx = await PublicVesaliusService.getVesaliusNextAvailableSlot(1, prn, o);
        }

        final ly = lx.where((x) => x.date == startDate).toList();
        ctrl.setIsLoading(false);
        if (ly.isEmpty) {
          showCustomDialog('Error', 'There is no available slot on your request date / time.', 'Dismiss');
        }

        else {
          Get.to(() => NewAppointment4(
            doctorInfo: widget.doctorInfo,
            doctorAppointmentStatus: widget.doctorAppointmentStatus,
            list: ly,
            isEdit: widget.isEdit,
          ));
        }
      }

      on DioException catch (error) {
        ctrl.setIsLoading(false);
        handleLoadError(error, onNext);
      }

      catch (_) {
        ctrl.setIsLoading(false);
        showCustomDialog('Error', 'Sorry, no appointment slots available based on the selection criteria. Please reset and search again.', 'Dismiss');
      }
    }
    
    else {
      ctrl.setAppointmentSession(ctrl.xappointmentSession);
      if (widget.isEdit) {
        Get.back();
        Get.back();
      }

      else {
        Get.to(() => ConfirmAppointment(
          doctorInfo: widget.doctorInfo,
          doctorAppointmentStatus: widget.doctorAppointmentStatus,
        ));
      }

      // String startTime = ctrl.appointmentSession!.startTime;
      // final s = formatDate(newAppointment2Ctrl.date!, [yyyy, '-', mm, '-', dd]);
      // final afternoonStartTime = DateTime.parse('${s}T13:00:00');
      // final mstartTime = DateTime.parse('${s}T$startTime:00');
      // if (mstartTime.compareTo(afternoonStartTime) <= 0 && ctrl.appointmentSession!.session == 'Afternoon') {
      //   startTime = '13:00';
      // }

      // try {
      //   final m = {
      //     'caseType': newAppointmentCtrl.caseTypeCode,
      //     'mcr': o.mcr,
      //     'specialtyCode': selectedSpecialtyCode,
      //     'startDate': startDate,
      //     'startTime': startTime,
      //   };
      //   ctrl.setIsLoading(true);
      //   final branchDetails = DataManager.branchDetails!;
      //   final lx = await VesaliusService.getVesaliusNextAvailableSlot(branchDetails.branch!.branchId!, branchDetails.prn!, m);
      //   final ly = lx.where(filterDate).toList();
      //   ctrl.setIsLoading(false);
      //   if (ly.isEmpty) {
      //     showCustomDialog('Error', 'There is no available slot on your request date / time.', 'Dismiss');
      //   }

      //   else {
      //     Get.to(() => NewAppointment4(
      //       doctorInfo: widget.doctorInfo,
      //       doctorAppointmentStatus: widget.doctorAppointmentStatus,
      //       appointmentSessions: widget.appointmentSessions,
      //       appointmentSession: ctrl.appointmentSession,
      //       time: ctrl.date,
      //       list: ly,
      //       isEdit: widget.isEdit,
      //     ));
      //   }
      // }

      // catch (_) {
      //   ctrl.setIsLoading(false);
      //   showCustomDialog('Error', 'Sorry, no appointment slots available based on the selection criteria. Please reset and search again.', 'Dismiss');
      // }
    }
  }

  void onSelectTime() {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TimePickerSpinner(
                  is24HourMode: false,
                  isForce2Digits: true,
                  normalTextStyle: const TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.7,
                    color: Color(0xFF9A99A2),
                  ),
                  highlightedTextStyle: const TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.7,
                    color: Color(0xFF232326),
                  ),
                  onTimeChange: (time) {
                    ctrl.setXDate(time);
                  },
                ),
                ElevatedButton(
                  onPressed:() {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50.0),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Text(
                    'Confirm Time',
                    style: kTextStyle1.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildNormal() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDADADA)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withValues(alpha: 0.1),
            offset: const Offset(0.0, 4.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: onSelectTime,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 19.0),
            child: Row(
              children: [
                Image.asset(
                  'images/icon/clock3.png',
                  width: 18.0,
                  height: 18.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 11.0),
                Expanded(
                  child: Obx(() =>
                    Text(
                      ctrl.time,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: kTextColor1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildSessionList() {
    List<Widget> lx = [];
    for (int i = 0; i < ctrl.appointmentSessionList.length; i++) {
      lx.addAll([
        SessionItem(data: ctrl.appointmentSessionList[i]),
        const SizedBox(height: 24.0),
      ]);
    }

    return lx;
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 40.0,
                child: Row(
                  children: [
                    Expanded(
                      child: TimelineTile(
                        axis: TimelineAxis.horizontal,
                        isFirst: true,
                        indicatorStyle: IndicatorStyle(
                          indicator: Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                '1',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        afterLineStyle: const LineStyle(
                          color: kPrimaryColor,
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Visit Type',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: TimelineTile(
                        axis: TimelineAxis.horizontal,
                        indicatorStyle: IndicatorStyle(
                          indicator: Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                '2',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: kPrimaryColor,
                          thickness: 1,
                        ),
                        afterLineStyle: const LineStyle(
                          color: kPrimaryColor,
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Select Date',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: TimelineTile(
                        axis: TimelineAxis.horizontal,
                        isLast: true,
                        indicatorStyle: IndicatorStyle(
                          indicator: Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: kBgColor1,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: kPrimaryColor),
                            ),
                            child: Center(
                              child: Text(
                                '3',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: kPrimaryColor,
                          thickness: 1,
                        ),
                        afterLineStyle: const LineStyle(
                          color: Color(0xFFDADADA),
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Select Slot',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          ctrl.appointmentSessionList.isEmpty ? 'What time do you prefer?' : 'Choose your preferred slot',
                          style: kTextStyle1.copyWith(
                            fontFamily: kFont2,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        if (ctrl.appointmentSessionList.isEmpty) ...[
                          buildNormal(),
                        ] else ...[
                          ...buildSessionList(),
                        ],
                        /* Obx(() =>
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: ctrl.timeSession == 'morning' ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withValues(alpha: 0.1),
                                  offset: const Offset(0.0, 4.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              child: InkWell(
                                onTap: () {
                                  ctrl.setTimeSession('morning');
                                },
                                borderRadius: BorderRadius.circular(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 19.0),
                                  child: Text(
                                    'Morning (8am-11am)',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: ctrl.timeSession == 'morning' ? kTextColor1 : kTextColor2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Obx(() =>
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: ctrl.timeSession == 'afternoon' ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withValues(alpha: 0.1),
                                  offset: const Offset(0.0, 4.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              child: InkWell(
                                onTap: () {
                                  ctrl.setTimeSession('afternoon');
                                },
                                borderRadius: BorderRadius.circular(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 19.0),
                                  child: Text(
                                    'Afternoon (2pm-5pm)',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: ctrl.timeSession == 'afternoon' ? kTextColor1 : kTextColor2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ), */
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Next',
                    onPressed: (ctrl.xappointmentSession == null && ctrl.appointmentSessionList.isNotEmpty) || (ctrl.xdate == null && ctrl.appointmentSessionList.isEmpty) ? null : onNext,
                  ),
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
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
    return InnerPage(
      title: 'Make An Appointment',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}

class SessionItem extends StatelessWidget {

  final AppointmentSession data;
  final NewAppointment3Ctrl ctrl = Get.put(NewAppointment3Ctrl());

  SessionItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: ctrl.xappointmentSession?.session == data.session && ctrl.xappointmentSession?.slot?.slotNumber == data.slot?.slotNumber ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: kBgColor2.withValues(alpha: 0.1),
              offset: const Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              ctrl.setXAppointmentSession(data);
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 19.0),
              child: Text(
                data.toString(),
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: ctrl.xappointmentSession?.session == data.session && ctrl.xappointmentSession?.slot?.slotNumber == data.slot?.slotNumber ? kTextColor1 : kTextColor2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}