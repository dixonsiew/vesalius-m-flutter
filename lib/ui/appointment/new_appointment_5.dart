import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/appointment/step.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import '../appointment.dart';

class NewAppointment5 extends StatefulWidget {
  
  final String selectedCaseType;
  final DateTime selectedDate;
  final TimeOfDay? selectedTime;
  final String? selectedTimeSession;
  final String? selectedDoctorName;
  final String? selectedSpecialtyName;
  final DoctorInfo? doctorInfo;
  final AvailableSlot? selectedSlot;

  const NewAppointment5({
    Key? key, 
    required this.selectedCaseType,
    required this.selectedDate,
    this.selectedTime,
    this.selectedTimeSession,
    required this.selectedDoctorName,
    required this.selectedSpecialtyName,
    required this.doctorInfo,
    required this.selectedSlot,
  }) : super(key: key);

  @override
  State<NewAppointment5> createState() => _NewAppointment5State();
}

class _NewAppointment5State extends State<NewAppointment5> {

  bool isScroll = false;
  bool isLoading = false;

  String getSelectedCaseType() {
    String s = 'NC';

    if (widget.selectedCaseType == 'Follow-up') {
      s = 'FU';
    }

    return s;
  }

  String getSelectedDate() {
    String s = 'NA';
    final format = DateFormat('d MMM y');
    s = format.format(widget.selectedDate);
    return s;
  }

  String getSelectedTime() {
    String s = '';
    if (widget.selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, widget.selectedTime!.hour, widget.selectedTime!.minute);
      final format = DateFormat.jm();  //"6:00 AM"
    s = format.format(dt);
    }
    
    return s;
  }

  String getTime(String s) {
    List<String> a = s.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  Future<void> showSuccess() async {
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 29.0, bottom: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 54.0,
              height: 54.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 17.0),
            Text(
              'Appointment Created',
              style: kLabelTextStyle.copyWith(
                fontFamily: kMainFont,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'New appointment is created on',
              style: kBodyTextStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5.0),
            Text(
              '${getDate(widget.selectedSlot!.date!)}, ${getTime(widget.selectedSlot!.startTime!)}.',
              style: kBodyTextStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kMainColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
              child: Text(
                'Done',
                style: kMainTextStyle.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onConfirm() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserBranch? branchDetails = DataManager.branchDetails;
      final data = {
        'branchId': branchDetails!.branch!.branchId!,
        'caseType': getSelectedCaseType(),
        'slotNumber': widget.selectedSlot!.slotNumber!,
      };
      await postVesaliusMakeAppointment(branchDetails.prn!, data);
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
      setState(() {
        isLoading = false;
      });
      await showSuccess();
      Get.offAllNamed(Appointment.routeName);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Failed', 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  Widget buildStep5() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              thickness: 1.0,
              color: Color(0xFFC4C4C4),
            ),
          ),
          AppStep.buildStep(5),
        ],
      ),
    );
  }

  Widget buildContentAMPM() {
    return Stack(
      children: [
        Scrollbar(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                setState(() {
                  isScroll = true;
                });
              }

              else if (scrollNotification is ScrollEndNotification) {
                setState(() {
                  isScroll = false;
                });
              }

              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 72.0),
                  Container(
                    height: MediaQuery.of(context).size.height - 140,
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64.0,
                              height: 64.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('images/imgs/pic.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.selectedDoctorName!.trim(),
                                    style: kMainTextStyle.copyWith(
                                      fontFamily: kBodyFont,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    widget.selectedSpecialtyName!.trim(),
                                    style: kMainTextStyle.copyWith(
                                      fontFamily: kBodyFont,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF8C8C8C),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/icon/location1.png',
                                        width: 16.0,
                                        height: 16.0,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Room 212, Level 2',
                                        style: kMainTextStyle.copyWith(
                                          fontFamily: kBodyFont,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: kMainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17.0),
                        const Divider(
                          thickness: 1.0,
                          color: Color(0xFFE9E8E8),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Visit Type',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 20.0, top: 19.0, bottom: 19.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7FDFF),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.selectedCaseType,
                                  style: kTitleTextStyle.copyWith(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'images/icon/edit.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          'Selected Date & Preferred Time',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 20.0, top: 19.0, bottom: 19.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7FDFF),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/icon/clock1.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  widget.selectedTimeSession == 'AM' ? 'Morning (8am-11am)' : 'Afternoon (2pm-5pm)',
                                  style: kTitleTextStyle.copyWith(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'images/icon/edit.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: isScroll == false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                color: const Color(0xFFF8F8F8),
                child: buildStep5(),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: isScroll == false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 42.0),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 54.0),
                      child: Text(
                        '*Please ensure all the appointment details are correct before you proceed',
                        style: kMainTextStyle.copyWith(
                          fontFamily: kBodyFont,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 33.0),
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: kMainColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        ),
                        child: Text(
                          'Next',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 33.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kMainColor,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          side: const BorderSide(
                            color: Color(0xFFDBDBDB),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: kMainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        Scrollbar(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                setState(() {
                  isScroll = true;
                });
              }

              else if (scrollNotification is ScrollEndNotification) {
                setState(() {
                  isScroll = false;
                });
              }

              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 72.0),
                  Container(
                    height: MediaQuery.of(context).size.height - 40,
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64.0,
                              height: 64.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('images/imgs/pic.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.selectedDoctorName!.trim(),
                                    style: kMainTextStyle.copyWith(
                                      fontFamily: kBodyFont,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    widget.selectedSpecialtyName!.trim(),
                                    style: kMainTextStyle.copyWith(
                                      fontFamily: kBodyFont,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF8C8C8C),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/icon/location1.png',
                                        width: 16.0,
                                        height: 16.0,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Room 212, Level 2',
                                        style: kMainTextStyle.copyWith(
                                          fontFamily: kBodyFont,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: kMainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17.0),
                        const Divider(
                          thickness: 1.0,
                          color: Color(0xFFE9E8E8),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Visit Type',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 20.0, top: 19.0, bottom: 19.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7FDFF),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.selectedCaseType,
                                  style: kTitleTextStyle.copyWith(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'images/icon/edit.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          'Selected Date & Preferred Time',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 20.0, top: 19.0, bottom: 19.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7FDFF),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/icon/clock1.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  '${getSelectedDate()}, ${getSelectedTime()}',
                                  style: kTitleTextStyle.copyWith(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'images/icon/edit.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          'Selected Appointment Slot',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 20.0, top: 19.0, bottom: 19.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7FDFF),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/icon/clock1.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  '${getDate(widget.selectedSlot!.date!)}, ${getTime(widget.selectedSlot!.startTime!)}',
                                  style: kTitleTextStyle.copyWith(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'images/icon/edit.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: isScroll == false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                color: const Color(0xFFF8F8F8),
                child: buildStep5(),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Visibility(
            visible: isScroll == false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 54.0),
                      child: Text(
                        '*Please ensure all the appointment details are correct before you proceed',
                        style: kMainTextStyle.copyWith(
                          fontFamily: kBodyFont,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 33.0),
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: kMainColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        ),
                        child: Text(
                          'Confirm',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 33.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kMainColor,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          side: const BorderSide(
                            color: Color(0xFFDBDBDB),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: kMainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Appointment Details',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: buildContent(),
        ),
      ),
    );
  }
}