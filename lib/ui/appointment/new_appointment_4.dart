import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/appointment/step.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'new_appointment_5.dart';

class NewAppointment4 extends StatefulWidget {

  final String selectedCaseType;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String? selectedDoctorName;
  final String? selectedSpecialtyName;
  final DoctorInfo? doctorInfo;
  final List<AvailableSlot>? list;

  const NewAppointment4({
    Key? key, 
    required this.selectedCaseType,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedDoctorName,
    required this.selectedSpecialtyName,
    required this.doctorInfo,
    required this.list,
  }) : super(key: key);

  @override
  State<NewAppointment4> createState() => _NewAppointment4State();
}

class _NewAppointment4State extends State<NewAppointment4> {

  AvailableSlot? selectedSlot;
  String? slotNumber;
  bool isScroll = false;
  bool isLoading = false;

  String getTime(String s) {
    var a = s.split(':');
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

  void onNext() {
    Get.to(() => NewAppointment5(
      selectedCaseType: widget.selectedCaseType,
      selectedDate: widget.selectedDate,
      selectedTime: widget.selectedTime,
      selectedDoctorName: widget.selectedDoctorName,
      selectedSpecialtyName: widget.selectedSpecialtyName,
      doctorInfo: widget.doctorInfo,
      selectedSlot: selectedSlot,
    ));
  }

  List<Widget> buildSlots() {
    List<Widget> lx = [
      const SizedBox(height: 30.0),
      Text(
        'Choose your preferred slot',
        style: kTitleTextStyle.copyWith(
          fontSize: 22.0,
        ),
      ),
      const SizedBox(height: 30.0),
    ];
    if (widget.list != null) {
      for (var o in widget.list!) {
        final w = Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 19.0),
          decoration: BoxDecoration(
            color: slotNumber == o.slotNumber ? const Color(0xFFE7FDFF) : Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: slotNumber == o.slotNumber ? kMainColor : const Color(0xFFADADAD),
            ),
            boxShadow: [
              BoxShadow(
                color: slotNumber == o.slotNumber ? const Color.fromRGBO(219, 219, 219, 0.65) : const Color.fromRGBO(229, 229, 229, 0.1),
                offset: slotNumber == o.slotNumber ? Offset.zero : const Offset(0, 4.0),
                blurRadius: slotNumber == o.slotNumber ? 5.0 : 4.0,
              ),
            ],
          ),
          child: Text(
            '${getDate(o.date!)} , ${getTime(o.startTime!)}',
            style: kMainTextStyle.copyWith(
              fontFamily: kBodyFont,
              fontSize: 16.0,
              fontWeight: slotNumber == o.slotNumber ? FontWeight.w700 : FontWeight.w600,
              color: slotNumber == o.slotNumber ? const Color(0xFF002E50) : const Color(0xFF4E4E4E),
            ),
          ),
        );
        final iw = InkWell(
          onTap: () {
            setState(() {
              slotNumber = o.slotNumber;
              selectedSlot = o;
            });
          },
          child: w,
        );
        lx.add(iw);
        lx.add(const SizedBox(height: 20.0));
      }
    }

    return lx;
  }

  Widget buildStep4() {
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
          AppStep.buildStep(4),
        ],
      ),
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
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSlots(),
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
                child: buildStep4(),
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
                padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 42.0),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: selectedSlot == null ? null : onNext,
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
                    const SizedBox(height: 16.0),
                    OutlinedButton(
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
                  ],
                ),
              ),
            ),
          ),
        )
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
          'Make An Appointment',
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