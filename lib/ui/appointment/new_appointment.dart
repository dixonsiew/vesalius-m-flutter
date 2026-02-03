import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'new_appointment_2.dart';

class NewAppointment extends StatelessWidget {

  final DoctorInfo doctorInfo;
  final bool isEdit;

  NewAppointment({
    super.key,
    required this.doctorInfo,
    this.isEdit = false,
  });

  final NewAppointmentCtrl ctrl = Get.put(NewAppointmentCtrl());

  void onNext() {
    ctrl.setCaseType(ctrl.xcaseType);
    if (isEdit) {
      Get.back();
    }

    else {
      Get.to(() => NewAppointment2(doctorInfo: doctorInfo));
    }
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
                              color: const Color(0xFFF4F4F4).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xFFDADADA)),
                            ),
                            child: Center(
                              child: Text(
                                '2',
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
                        afterLineStyle: const LineStyle(
                          color: Color(0xFFDADADA),
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Select Date',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
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
                              color: const Color(0xFFF4F4F4).withValues(alpha: 0.8),
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
                            'Select Slot',
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Which type is your visit?',
                        style: kTextStyle1.copyWith(
                          fontFamily: kFont2,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Obx(() =>
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: ctrl.xcaseType == 'New Case' ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            child: InkWell(
                              onTap: () {
                                ctrl.setXCaseType('New Case');
                              },
                              borderRadius: BorderRadius.circular(5.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() =>
                                        Text(
                                          'New Case',
                                          style: kTextStyle1.copyWith(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: ctrl.xcaseType == 'New Case' ? kTextColor1 : kTextColor2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      'images/icon/new-case.png',
                                      width: 32.0,
                                      height: 32.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Obx(() =>
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: ctrl.xcaseType == 'Follow Up' ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            child: InkWell(
                              onTap: () {
                                ctrl.setXCaseType('Follow Up');
                              },
                              borderRadius: BorderRadius.circular(5.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() =>
                                        Text(
                                          'Follow Up',
                                          style: kTextStyle1.copyWith(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: ctrl.xcaseType == 'Follow Up' ? kTextColor1 : kTextColor2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      'images/icon/follow-up.png',
                                      width: 32.0,
                                      height: 32.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
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
                AppElevatedButton(
                  text: 'Next',
                  onPressed: ctrl.xcaseType.isEmpty ? null : onNext,
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

class EmptyTimeline extends StatelessWidget {

  final double width;
  final Color color;

  const EmptyTimeline({
    super.key,
    this.width = 90.0,
    this.color = const Color(0xFFDADADA),
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      indicatorStyle: IndicatorStyle(
        indicator: Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              '',
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w700,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
      endChild: SizedBox(width: width),
      beforeLineStyle: LineStyle(
        color: color,
        thickness: 1,
      ),
      afterLineStyle: LineStyle(
        color: color,
        thickness: 1,
      ),
    );
  }
}