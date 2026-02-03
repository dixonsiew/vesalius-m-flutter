import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_ctrl.dart';

import 'reschedule_appointment_2.dart';

class RescheduleAppointment extends StatefulWidget {
  
  static const String routeName = '/RescheduleAppointment';

  const RescheduleAppointment({super.key});

  @override
  State<RescheduleAppointment> createState() => _RescheduleAppointmentState();
}

class _RescheduleAppointmentState extends State<RescheduleAppointment> {
  
  final RescheduleAppointmentCtrl ctrl = Get.put(RescheduleAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setDate(minDate);
  }

  DateTime get minDate {
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
    Get.to(() => const RescheduleAppointment2());
  }

  Obx buildCalendar() {
    final calendarCarousel = Obx(
      () => CalendarCarousel<Event>(
        height: 410.0,
        staticSixWeekFormat: true,
        showOnlyCurrentMonthDate: true,
        customDayBuilder: (isSelectable, index, isSelectedDay, isToday,
            isPrevMonthDay, textStyle, isNextMonthDay, isThisMonthDay, day) {
          if (day == DateTime(2023, 1, 27) || day == DateTime(2023, 1, 28)) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFFF5050),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }

          return null;
        },
        headerTextStyle: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: kPrimaryColor,
        ),
        leftButtonIcon: Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: kPrimaryColor),
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_left,
              color: kPrimaryColor,
              size: 24.0,
            ),
          ),
        ),
        rightButtonIcon: Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: kPrimaryColor),
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_right,
              color: kPrimaryColor,
              size: 24.0,
            ),
          ),
        ),
        dayButtonColor: const Color(0xFFE1EDFF),
        todayBorderColor: kTextColor1,
        todayButtonColor: const Color(0xFF44A1E4),
        selectedDayBorderColor: kTextColor1,
        selectedDayButtonColor: kTextColor1,
        prevDaysTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
        daysTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
        todayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        selectedDayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        weekdayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFADADAD),
        ),
        weekendTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
        iconColor: kPrimaryColor,
        daysHaveCircularBorder: false,
        thisMonthDayBorderColor: const Color(0xFFE1EDFF),
        selectedDateTime: ctrl.date ?? minDate,
        minSelectedDate: minDate,
        onDayPressed: (date, events) {
          String w = DateFormat('EEEE').format(date);
          if (w != 'Sunday') {
            ctrl.setDate(date);
          }
        },
      ),
    );

    return calendarCarousel;
  }

  Widget buildLabels() {
    return Row(
      children: [
        Container(
          width: 16.0,
          height: 16.0,
          color: const Color(0xFF44A1E4),
        ),
        const SizedBox(width: 8.0),
        Text(
          'Today',
          style: kTextStyle1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: kTextColor4,
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          width: 16.0,
          height: 16.0,
          color: kTextColor1,
        ),
        const SizedBox(width: 8.0),
        Text(
          'Selected',
          style: kTextStyle1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: kTextColor4,
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          width: 16.0,
          height: 16.0,
          color: const Color(0xFFFF5050),
        ),
        const SizedBox(width: 8.0),
        Text(
          'Full',
          style: kTextStyle1.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: kTextColor4,
          ),
        ),
      ],
    );
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: kPrimaryColor),
                            ),
                            child: Center(
                              child: Text(
                                '1',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        afterLineStyle: const LineStyle(
                          color: Color(0xFFDADADA),
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Reselect Date',
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(color: const Color(0xFFDADADA)),
                            ),
                            child: Center(
                              child: Text(
                                '2',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kTextColor2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Color(0xFFDADADA),
                          thickness: 1,
                        ),
                        afterLineStyle: const LineStyle(
                          color: Color(0xFFDADADA),
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Reselect Time',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
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
                              color: const Color(0xFFF4F4F4).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                                  Border.all(color: const Color(0xFFDADADA)),
                            ),
                            child: Center(
                              child: Text(
                                '3',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: kTextColor2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        beforeLineStyle: const LineStyle(
                          color: Color(0xFFDADADA),
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Select New Slot',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
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
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Which date do you prefer?',
                            style: kTextStyle1.copyWith(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                          // const SizedBox(height: 24.0),
                          // const SizedBox(height: 27.0),
                          buildCalendar(),
                          const SizedBox(height: 16.0),
                          buildLabels(),
                          const SizedBox(height: 16.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1EDFF),
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withOpacity(0.1),
                                  offset: const Offset(0, 4.0),
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
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    'Please make your appointment at least 2 working days in advance.',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: kTextColor1,
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
                AppElevatedButton(
                  text: 'Next',
                  onPressed: ctrl.date == null ? null : onNext,
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
      title: 'Reschedule Appointment',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}
