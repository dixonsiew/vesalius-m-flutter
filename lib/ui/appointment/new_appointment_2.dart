import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/appointment/step.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'new_appointment_3.dart';

class NewAppointment2 extends StatefulWidget {

  final String selectedCaseType;
  final DoctorInfo? doctorInfo;

  const NewAppointment2({
    Key? key, 
    required this.selectedCaseType,
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<NewAppointment2> createState() => _NewAppointment2State();
}

class _NewAppointment2State extends State<NewAppointment2> {

  DateTime? selectedDate;
  bool isScroll = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final minDate = getMinDate();
    selectedDate = minDate;
  }

  DateTime getMinDate() {
    DateTime today = DateTime.now();
    String tw = DateFormat('EEEE').format(today);
    DateTime dt = today.add(const Duration(days: 3));
    if (tw == 'Friday' || tw == 'Saturday' || tw == 'Thursday') {
      dt = today.add(const Duration(days: 4)); // skip Sunday
    }

    final minDate = DateTime(dt.year, dt.month, dt.day);
    return minDate;
  }

  void onNext() {
    Get.to(() => NewAppointment3(
      selectedCaseType: widget.selectedCaseType,
      selectedDate: selectedDate!,
      doctorInfo: widget.doctorInfo,
    ));
  }

  CalendarCarousel<Event> getCalendar() {
    final minDate = getMinDate();

    final calendarCarousel = CalendarCarousel<Event>(
      height: 410.0,
      staticSixWeekFormat: true,
      headerTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Color(0xFF4E4E4E),
      ),
      leftButtonIcon: Image.asset(
        'images/icon/previous.png',
        width: 24.0,
        height: 24.0,
        fit: BoxFit.cover,
      ),
      rightButtonIcon: Image.asset(
        'images/icon/next1.png',
        width: 24.0,
        height: 24.0,
        fit: BoxFit.cover,
      ),
      dayButtonColor: const Color(0xFFE1EDFF),
      todayBorderColor: const Color(0xFF44A1E4),
      todayButtonColor: const Color(0xFF44A1E4),
      selectedDayBorderColor: kMainColor,
      selectedDayButtonColor: kMainColor,
      prevDaysTextStyle: kMainTextStyle.copyWith(
        fontFamily: kBodyFont,
        fontSize: 12.0,
      ),
      daysTextStyle: kMainTextStyle.copyWith(
        fontFamily: kBodyFont,
        fontSize: 12.0,
      ),
      todayTextStyle: kTitleTextStyle.copyWith(
        fontSize: 12.0,
        color: Colors.white,
      ),
      selectedDayTextStyle: kTitleTextStyle.copyWith(
        fontSize: 12.0,
        color: Colors.white,
      ),
      weekdayTextStyle: kMainTextStyle.copyWith(
        fontFamily: kBodyFont,
        fontSize: 12.0,
        color: const Color(0xFFADADAD),
      ),
      weekendTextStyle: kMainTextStyle.copyWith(
        fontFamily: kBodyFont,
        fontSize: 12.0,
      ),
      iconColor: Colors.black,
      daysHaveCircularBorder: false,
      thisMonthDayBorderColor: const Color(0xFF8C8C8C),
      selectedDateTime: selectedDate ?? minDate,
      minSelectedDate: minDate,
      onDayPressed: (date, events) {
        var w = DateFormat('EEEE').format(date);
        if (w != 'Sunday') {
          setState(() {
            selectedDate = date;
          });
        }
      },
    );

    return calendarCarousel;
  }

  Widget buildLabels() {
    return Row(
      children: [
        Image.asset(
          'images/icon/today.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 8.0),
        Text(
          'Today',
          style: kMainTextStyle.copyWith(
            fontFamily: kBodyFont,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10.0),
        Image.asset(
          'images/icon/select.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 8.0),
        Text(
          'Selected',
          style: kMainTextStyle.copyWith(
            fontFamily: kBodyFont,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10.0),
        Image.asset(
          'images/icon/full.png',
          width: 16.0,
          height: 16.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 8.0),
        Text(
          'Full',
          style: kMainTextStyle.copyWith(
            fontFamily: kBodyFont,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildStep2() {
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
          AppStep.buildStep(2),
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
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 72.0),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height + 60,
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30.0),
                      Text(
                        'Which date do you prefer?',
                        style: kTitleTextStyle.copyWith(
                          fontSize: 22.0,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1EDFF),
                          borderRadius: BorderRadius.circular(5.0),
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
                              'images/icon/info.png',
                              width: 16.0,
                              height: 16.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                'Please make your appointment at least 2 working days in advance.',
                                style: kBodyTextStyle.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      getCalendar(),
                      const SizedBox(height: 16.0),
                      buildLabels(),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
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
                child: buildStep2(),
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
                      onPressed: selectedDate == null ? null : onNext,
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