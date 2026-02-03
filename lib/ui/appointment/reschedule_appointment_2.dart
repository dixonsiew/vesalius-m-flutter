import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_2_ctrl.dart';

import 'reschedule_appointment_3.dart';

class RescheduleAppointment2 extends StatefulWidget {

  static const String routeName = '/RescheduleAppointment2';

  const RescheduleAppointment2({super.key});

  @override
  State<RescheduleAppointment2> createState() => _RescheduleAppointment2State();
}

class _RescheduleAppointment2State extends State<RescheduleAppointment2> {

  final RescheduleAppointment2Ctrl ctrl = Get.put(RescheduleAppointment2Ctrl());

  void onNext() {
    Get.to(() => const RescheduleAppointment3());
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
                    ctrl.setDate(time);
                  },
                ),
                ElevatedButton(
                  onPressed:() {
                    String s = formatDate(ctrl.date!, [h, ':', nn, ' ', am]);
                    ctrl.setTime(s);
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
                              color: kBgColor1,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: kPrimaryColor),
                            ),
                            child: Center(
                              child: Text(
                                '2',
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
                            'Reselect Time',
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
                              color: const Color(0xFFF4F4F4).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xFFDADADA)),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'What time do you prefer?',
                        style: kTextStyle1.copyWith(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFDADADA)),
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withOpacity(0.1),
                              offset: const Offset(0, 4.0),
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
                      ),
                    ],
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
                    onPressed: ctrl.time == 'Select A Time' ? null : onNext,
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
      title: 'Reschedule Appointment',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}
