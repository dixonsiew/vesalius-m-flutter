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
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'new_appointment_4.dart';
import 'new_appointment_5.dart';

class NewAppointment3 extends StatefulWidget {
  
  final String selectedCaseType;
  final DateTime selectedDate;
  final DoctorInfo? doctorInfo;

  const NewAppointment3({
    Key? key, 
    required this.selectedCaseType,
    required this.selectedDate,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<NewAppointment3> createState() => _NewAppointment3State();
}

class _NewAppointment3State extends State<NewAppointment3> {

  TimeOfDay? selectedTime;
  String? selectedTimeSession;
  bool isLoading = false;

  String getSelectedCaseType() {
    String s = 'NC';

    if (widget.selectedCaseType == 'Follow-up') {
      s = 'FU';
    }

    return s;
  }

  String getSelectedTime() {
    String s = 'Select A Time';

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
      final format = DateFormat.jm();  //"6:00 AM"
      s = format.format(dt);
    }

    return s;
  }

  void onCheckAvailability() async {
    String? selectedDoctorMcr;
    String? selectedSpecialtyCode = '';
    String? selectedSpecialtyName = '';
    String? selectedDoctorName;
    final formatDate = DateFormat('d-MMM-y');
    String dts = '06:00';

    if (widget.doctorInfo != null) {
      final o = widget.doctorInfo!;
      var doctorSpecialty = o.doctorSpecialty ?? [];
      var specialty = doctorSpecialty.isEmpty ? null : doctorSpecialty.first.specialty;
      selectedDoctorMcr = o.mcr;
      selectedDoctorName = o.name;
      if (specialty != null) {
        selectedSpecialtyCode = specialty.specialtyCode;
        selectedSpecialtyName = specialty.specialtyDesc;
      }
    }

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
      final formatTime = DateFormat.Hm();
      dts = formatTime.format(dt);
    }

    Map m = {
      'caseType': getSelectedCaseType(),
      'mcr': selectedDoctorMcr,
      'specialtyCode': selectedSpecialtyCode,
      'startDate': formatDate.format(widget.selectedDate),
      'startTime': dts,
    };
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      var lx = await getVesaliusNextAvailableSlot(branchDetails!.branch!.branchId!, branchDetails.prn!, m);
      setState(() {
        isLoading = false;
      });
      if (lx.isEmpty) {
        showCustomDialog('Failed', 'There is no available slot on your request date / time.', 'Dismiss');
      }

      else {
        Get.to(() => NewAppointment4(
          selectedCaseType: widget.selectedCaseType,
          selectedDate: widget.selectedDate,
          selectedTime: selectedTime!,
          selectedDoctorName: selectedDoctorName,
          selectedSpecialtyName: selectedSpecialtyName,
          doctorInfo: widget.doctorInfo,
          list: lx,
        ));
      }
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Failed', 'Sorry, no appointment slots available based on the selection criteria. Please reset and search again.', 'Dismiss');
    }
  }

  void onNextAMPM() {
    String? selectedSpecialtyName = '';
    String? selectedDoctorName;

    if (widget.doctorInfo != null) {
      final o = widget.doctorInfo!;
      var doctorSpecialty = o.doctorSpecialty ?? [];
      var specialty = doctorSpecialty.isEmpty ? null : doctorSpecialty.first.specialty;
      selectedDoctorName = o.name;
      if (specialty != null) {
        selectedSpecialtyName = specialty.specialtyDesc;
      }
    }

    Get.to(() => NewAppointment5(
      selectedCaseType: widget.selectedCaseType,
      selectedDate: widget.selectedDate,
      selectedTime: selectedTime,
      selectedTimeSession: selectedTimeSession,
      selectedDoctorName: selectedDoctorName,
      selectedSpecialtyName: selectedSpecialtyName,
      doctorInfo: widget.doctorInfo,
      selectedSlot: null,
    ));
  }

  void onNext() {
    onCheckAvailability();
  }

  void onSelectTime() async {
    var mselectedTime = await showTimePicker(
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: '',
      confirmText: 'SELECT TIME',
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: kMainColor,
              colorScheme: const ColorScheme.light(
                primary: kMainColor,
              ),
              timePickerTheme: TimePickerTheme.of(context).copyWith(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                helpTextStyle: const TextStyle(
                  fontFamily: kBodyFont,
                ),
                dayPeriodTextStyle: const TextStyle(
                  fontFamily: kBodyFont,
                ),
                hourMinuteTextStyle: const TextStyle(
                  fontFamily: kBodyFont,
                  fontSize: 50.0,
                ),
              ),
            ),
            child: child!,
          ),
        );
      }
    );
    if (mselectedTime != null) {
      setState(() {
        selectedTime = mselectedTime;
      });
    }
  }

  Widget buildStep3() {
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
          AppStep.buildStep(3),
        ],
      ),
    );
  }

  Widget buildContentAMPM() {
    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30.0),
                      Text(
                        'What time do you prefer?',
                        style: kTitleTextStyle.copyWith(
                          fontSize: 22.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedTimeSession = 'AM';
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 27.0, bottom: 27.0),
                          decoration: BoxDecoration(
                            color: selectedTimeSession == 'AM' ? const Color(0xFFE7FDFF) : Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: selectedTimeSession == 'AM' ? kMainColor : const Color(0xFFADADAD),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(219, 219, 219, 0.6),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Text(
                            'Morning (8am-11am)',
                            style: kTitleTextStyle.copyWith(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedTimeSession = 'PM';
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 27.0, bottom: 27.0),
                          decoration: BoxDecoration(
                            color: selectedTimeSession == 'PM' ? const Color(0xFFE7FDFF) : Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: selectedTimeSession == 'PM' ? kMainColor : const Color(0xFFADADAD),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(219, 219, 219, 0.6),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Text(
                            'Afternoon (2pm-5pm)',
                            style: kTitleTextStyle.copyWith(
                              fontSize: 16.0,
                            ),
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
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            color: const Color(0xFFF8F8F8),
            child: buildStep3(),
          ),
        ),
        Align(
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
                  onPressed: selectedTimeSession == '' ? null : onNextAMPM,
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
      ],
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 72.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    Text(
                      'What time do you prefer?',
                      style: kTitleTextStyle.copyWith(
                        fontSize: 22.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    InkWell(
                      onTap: () {
                        onSelectTime();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 21.0, top: 19.0, bottom: 19.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFADADAD)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(229, 229, 229, 0.1),
                              offset: Offset(0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/icon/clock1.png',
                              width: 18.0,
                              height: 18.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                getSelectedTime(),
                                style: kMainTextStyle.copyWith(
                                  fontFamily: kBodyFont,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Image.asset(
                              'images/icon/right-arrow1.png',
                              width: 14.0,
                              height: 14.0,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            color: const Color(0xFFF8F8F8),
            child: buildStep3(),
          ),
        ),
        Align(
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
                  onPressed: selectedTime == null ? null : onNext,
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