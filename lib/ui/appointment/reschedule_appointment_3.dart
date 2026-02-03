import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_3_ctrl.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'confirm_reschedule.dart';

class RescheduleAppointment3 extends StatelessWidget {

  final PatientAppointment patientAppointment;
  final DoctorAppointmentStatus doctorAppointmentStatus;
  final List<AvailableSlot> list;

  final RescheduleAppointment3Ctrl ctrl = Get.put(RescheduleAppointment3Ctrl());

  RescheduleAppointment3({
    super.key,
    required this.patientAppointment,
    required this.doctorAppointmentStatus,
    required this.list,
  });

  void onNext() {
    ctrl.setSlot(ctrl.xslot);
    Get.to(() => ConfirmReschedule(
      patientAppointment: patientAppointment,
    ));
  }

  List<Widget> buildSlots() {
    List<Widget> lx = [];
    for (int i = 0; i < list.length; i++) {
      lx.addAll([
        SlotItem(data: list[i]),
        const SizedBox(height: 20.0),
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
                        isLast: true,
                        indicatorStyle: IndicatorStyle(
                          indicator: Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F4).withValues(alpha: 0.8),
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
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Select New Slot',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
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
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Choose your preferred slot',
                            style: kTextStyle1.copyWith(
                              fontFamily: kFont2,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          ...buildSlots(),
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
                Obx(() =>
                  AppElevatedButton(
                    text: 'Next',
                    onPressed: ctrl.xslot == null ? null : onNext,
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

class SlotItem extends StatelessWidget {

  final AvailableSlot data;
  final RescheduleAppointment3Ctrl ctrl = Get.put(RescheduleAppointment3Ctrl());

  SlotItem({
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
          border: Border.all(color: ctrl.xslot?.slotNumber == data.slotNumber ? kTextColor1 : const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
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
              ctrl.setXSlot(data);
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 19.0),
              child: Text(
                data.toString(),
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: ctrl.xslot?.slotNumber == data.slotNumber ? kTextColor1 : kTextColor2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}