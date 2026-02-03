import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/reschedule_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/public_service.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

import 'reschedule_appointment_2.dart';

class RescheduleAppointment extends StatefulWidget {

  final PatientAppointment patientAppointment;
  final DoctorInfo? doctorInfo;

  const RescheduleAppointment({
    super.key,
    required this.patientAppointment,
    this.doctorInfo,
  });

  @override
  State<RescheduleAppointment> createState() => _RescheduleAppointmentState();
}

class _RescheduleAppointmentState extends State<RescheduleAppointment> {

  List<DoctorAppointmentStatus> list = [];
  List<DoctorAppointment> doctorAppointments = [];
  
  final RescheduleAppointmentCtrl ctrl = Get.put(RescheduleAppointmentCtrl());
  final RescheduleAppointment2Ctrl rescheduleAppointment2Ctrl = Get.put(RescheduleAppointment2Ctrl());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load(minDate, true));
  }

  void load(DateTime dt, bool init) async {
    try {
      ctrl.setIsLoading(true);
      ctrl.setList([], []);

      if (widget.doctorInfo != null) {
        ctrl.setDocInfo(widget.doctorInfo);
      }

      else {
        UserBranch? branchDetails = DataManager.instance.branchDetails;
        DoctorInfo? o = await PublicVesaliusService.getDoctorByMCR(branchDetails!.branch!.branchId!, widget.patientAppointment.mcr!);
        ctrl.setDocInfo(o);
      }

      DateTime now = DateTime.now();
      DateTime af = DateTime(now.year, now.month, now.day, 12, 0);
      bool isAfterNoon = now.isAfter(af);
      
      final m = await VesaliusService.getDoctorAppointments(widget.patientAppointment.doctorId, dt.month, dt.year, init ? 1 : 0);
      list = m['calendarDailyStatus'];
      List<DoctorAppointmentStatus> lfull = list.where((o) => o.dailyStatus == 'FULL').toList();
      List<DoctorAppointmentStatus> lna = list.where((o) => o.dailyStatus == 'NOT AVAILABLE').toList();
      DoctorAppointmentStatus? a = list.firstWhereOrNull((o) => o.dailyStatus == 'AVAILABLE' && o.calendarDateDt.compareTo(minDate) >= 0);
      ctrl.setList(lfull, lna);
      if (init) {
        doctorAppointments = m['doctorAppointment'];
        if (a == null) {
          if (isAfterNoon) {
            ctrl.setXDate(null);
          }

          else {
            ctrl.setXDate(minDate);
          }
        }
      }

      if (a != null) {
        if (a.calendarDateDt.compareTo(minDate) >= 0) {
          if (isSameDate(a.calendarDateDt, minDate) && isAfterNoon) {
            ctrl.setXDate(null);
          }

          else {
            ctrl.setXDate(a.calendarDateDt);
          }
        }
        
        else {
          if (isAfterNoon) {
            ctrl.setXDate(null);
          }

          else {
            ctrl.setXDate(minDate);
          }
        }
      }
      
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, () => load(dt, init));
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  DateTime get minDate0 {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
    /* DateTime today = DateTime.now();
    String tw = DateFormat('EEEE').format(today);
    DateTime dt = today.add(const Duration(days: 3));
    if (tw == 'Friday' || tw == 'Saturday' || tw == 'Thursday') {
      dt = today.add(const Duration(days: 4)); // skip Sunday
    }

    DateTime mindt = DateTime(dt.year, dt.month, dt.day);
    return mindt; */
  }

  DateTime get minDate {
    DateTime today = DateTime.now();
    String tw = DateFormat('EEEE').format(today);
    DateTime dt = today.add(const Duration(days: 3));
    if (tw == 'Friday' || tw == 'Saturday' || tw == 'Thursday') {
      dt = today.add(const Duration(days: 4)); // skip Sunday
    }

    DateTime mindt = DateTime(dt.year, dt.month, dt.day);
    return mindt;
  }

  DateTime get now {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Color get selectedDayButtonColor {
    Color k = kPrimaryColor;
    bool b = ctrl.fullList.any((o) => isSameDate(o.calendarDateDt, ctrl.date));
    bool v = ctrl.naList.any((o) => isSameDate(o.calendarDateDt, ctrl.date));
    if (b) {
      k = kColor19;
    }

    if (v) {
      k = Colors.black45;
    }

    return k;
  }

  bool isSameDate(DateTime da, DateTime? db) {
    return da.year == db?.year && da.month == db?.month && da.day == db?.day;
  }

  bool get isTodayNotSelectable {
    DateTime now = DateTime.now();
    /* if (ctrl.mx != null) {
      return ctrl.mx!.markedDates.any((x) => isSameDate(x.date, now));
    } */

    bool b1 = ctrl.fullList.any((x) => isSameDate(x.calendarDateDt, now));
    bool b2 = ctrl.naList.any((x) => isSameDate(x.calendarDateDt, now));
    return b1 | b2;
  }

  void showError() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/error1.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Oops! It seems someone has just reserved the slot.\nPlease select a different date or reach out to our customer service for further assistance.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            /* const SizedBox(height: 8.0),
            Text(
              'Please choose another slot.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ), */
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    ));
  }

  Future<List<AppointmentSession>> getSessionSlots(List<AppointmentSession> lx) async {
    List<AppointmentSession> ls = [];

    try {
      ctrl.setIsLoading(true);
      final branchDetails = DataManager.instance.branchDetails!;
      final formatDatex = DateFormat('dd-MMM-y');
      String? selectedSpecialtyCode = '';
      final startDate = formatDatex.format(ctrl.date!);
      final doc = ctrl.doctorInfo;
      final doctorSpecialty = doc?.doctorSpecialty;
      final specialtyCode = doctorSpecialty?.isEmpty ?? true ? null : doctorSpecialty?.firstWhereOrNull((x) => x.primarySpecialty == true)?.specialty?.specialtyCode;
      if (specialtyCode != null) {
        selectedSpecialtyCode = specialtyCode;
      }

      else {
        ctrl.setIsLoading(false);
        await showCustomDialog('Error', 'No specialty found on this doctor', 'Dismiss');
        return ls;
      }

      final o = {
        'caseType': widget.patientAppointment.apptCaseType,
        'mcr': widget.patientAppointment.mcr,
        'doctorId': widget.patientAppointment.doctorId,
        'specialtyCode': selectedSpecialtyCode,
        'startDate': startDate,
        'startTime': isTodayNotSelectable == false && isSameDate(DateTime.now(), ctrl.date!) ? '13:00' : '07:00'
      };
      final li = await PublicVesaliusService.getVesaliusNextSessionAvailableSlot(branchDetails.branch!.branchId!, widget.patientAppointment.apptPatientPrn ?? branchDetails.prn!, o);
      final lj = li.where((x) => x.date == startDate).toList();
      for (int i = 0; i < lj.length; i++) {
        final slot = lj[i];
        if (slot.sessionType == 'MORNING') {
          AppointmentSession op = lx.firstWhere((x) => x.session == 'Morning');
          op.slot = slot;
          ls.add(op);
        }

        else if (slot.sessionType == 'AFTERNOON') {
          AppointmentSession op = lx.firstWhere((x) => x.session == 'Afternoon');
          op.slot = slot;
          ls.add(op);
        }
        // final s = formatDate(ctrl.date!, [yyyy, '-', mm, '-', dd]);
        // final slotStartTime = DateTime.parse('${s}T${slot.startTime}:00');
        // final afternoonStartTime = DateTime.parse('${s}T13:00:00');
        // if (slotStartTime.compareTo(afternoonStartTime) < 0) {
        //   AppointmentSession op = lx.firstWhere((x) => x.session == 'Morning');
        //   op.slot = slot;
        //   ls.add(op);
        // }

        // else {
        //   AppointmentSession op = lx.firstWhere((x) => x.session == 'Afternoon');
        //   op.slot = slot;
        //   ls.add(op);
        // }
      }

      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, onNext);
      if (error.type == DioExceptionType.connectionError) {
        rethrow;
      }
    }

    catch (_) {
      ctrl.setIsLoading(false);
    }

    return ls;
  }

  void onNext() async {
    ctrl.setDate(ctrl.xdate);
    bool conError = false;
    DateFormat fmt = DateFormat('dd/MM/yyyy');
    String ds = fmt.format(ctrl.date!);
    DoctorAppointmentStatus o = list.firstWhere((x) => x.calendarDate == ds);
    List<AppointmentSession> lx = [];
    List<AppointmentSession> ls = [];
    if (o.normalStatus == 'AVAILABLE') {

    }

    else {
      rescheduleAppointment2Ctrl.setXAppointmentSession(null);
      String w = DateFormat('EEEE').format(o.calendarDateDt).toUpperCase();
      if (o.morningStatus == 'AVAILABLE') {
        final k = doctorAppointments.firstWhereOrNull((x) => x.apptDayOfWeek == w && x.apptSlotType == 'SESSION' && x.apptSessionType == 'MORNING');
        if (k != null) {
          lx.add(AppointmentSession(session: 'Morning', startTime: k.apptStartTime, endTime: k.apptEndTime));
        }
        
        else {
          showCustomDialog('No Slot', 'No Appointment Slot Available', 'Dismiss');
          return;
        }
      }

      if (o.afternoonStatus == 'AVAILABLE') {
        final k = doctorAppointments.firstWhereOrNull((x) => x.apptDayOfWeek == w && x.apptSlotType == 'SESSION' && x.apptSessionType == 'AFTERNOON');
        if (k != null) {
          lx.add(AppointmentSession(session: 'Afternoon', startTime: k.apptStartTime, endTime: k.apptEndTime));
        }
        
        else {
          showCustomDialog('No Slot', 'No Appointment Slot Available', 'Dismiss');
          return;
        }
      }

      if (o.nightStatus == 'AVAILABLE') {
        final k = doctorAppointments.firstWhereOrNull((x) => x.apptDayOfWeek == w && x.apptSlotType == 'SESSION' && x.apptSessionType == 'NIGHT');
        if (k != null) {
          lx.add(AppointmentSession(session: 'Night', startTime: k.apptStartTime, endTime: k.apptEndTime));
        }
        
        else {
          showCustomDialog('No Slot', 'No Appointment Slot Available', 'Dismiss');
          return;
        }
      }

      try {
        ls = await getSessionSlots(lx);
      }

      on DioException catch (error) {
        if (error.type == DioExceptionType.connectionError) {
          conError = true;
        }
      }

      rescheduleAppointment2Ctrl.setAppointmentSessionList(ls);
      if (ls.isEmpty && !conError) {
        showError();
        return;
      }
    }

    if (!conError) {
      Get.to(() => RescheduleAppointment2(
        patientAppointment: widget.patientAppointment,
        doctorAppointmentStatus: o,
      ));
    }
  }

  Obx buildCalendar() {
    final config = CalendarDatePicker2Config(
      centerAlignModePicker: true,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      selectableDayPredicate: (day) {
        String w = formatDate(day, [D]);
        bool isFull = ctrl.fullList.any((x) => isSameDate(x.calendarDateDt, day));
        bool isNA = ctrl.naList.any((x) => isSameDate(x.calendarDateDt, day));
        bool b = isFull | isNA;
        if (b == false && w != 'Sun') {
          return true;
        }

        return false;
      },
      dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
        bool isFull = ctrl.fullList.any((x) => isSameDate(x.calendarDateDt, date));
        bool isNA = ctrl.naList.any((x) => isSameDate(x.calendarDateDt, date));
        if (isToday == true && isSelected == false && isTodayNotSelectable == false) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: kColor9,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle?.copyWith(color: Colors.white),
              ),
            ),
          );
        }

        else if (isSelected == true && isFull == false && isNA == false) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: ctrl.isLoading ? kSecondaryColor : selectedDayButtonColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle,
              ),
            ),
          );
        }

        else if (isFull) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: kColor19,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle?.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 3.0,
                ),
              ),
            ),
          );
        }

        else if (isNA) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle?.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 3.0,
                ),
              ),
            ),
          );
        }

        String s = formatDate(date, [D]);
        if (s == 'Sun') {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle?.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 3.0,
                ),
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(5.0),
            border: isDisabled == true ? null : Border.all(color: kPrimaryColor),
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: textStyle,
            ),
          ),
        );
      },
      lastMonthIcon: Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: kPrimaryColor2),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_left,
            color: kPrimaryColor2,
            size: 24.0,
          ),
        ),
      ),
      nextMonthIcon: Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: kPrimaryColor2),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_right,
            color: kPrimaryColor2,
            size: 24.0,
          ),
        ),
      ),
      firstDayOfWeek: 1,
      firstDate: minDate,
      lastDate: widget.patientAppointment.packageExpDateTime == null ? now.add(const Duration(days: kMaxAppointmentDay)) : widget.patientAppointment.packageExpDateTime!,
      controlsTextStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: kPrimaryColor2,
      ),
      dayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: kTextColor1,
      ),
      disabledDayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
      selectedDayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: ctrl.isLoading ? kTextColor1 : Colors.white,
      ),
      selectedDayHighlightColor: selectedDayButtonColor,
      todayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
    return Obx(() =>
      CalendarDatePicker2(
        config: config,
        value: [ctrl.xdate],
        onValueChanged: (dates) {
          DateTime date = dates.first;
          ctrl.setXDate(date);
        },
        onDisplayedMonthChanged: (dt) {
          ctrl.setXDate(dt);
          load(dt, false);
        },
      ),
    );
  }

  /* Obx buildCalendar() {
    final calendarCarousel = Obx(() =>
      CalendarCarousel<Event>(
        height: 410.0,
        customGridViewPhysics: const NeverScrollableScrollPhysics(),
        staticSixWeekFormat: true,
        showOnlyCurrentMonthDate: true,
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
        dayButtonColor: kSecondaryColor,
        todayBorderColor: isTodayNotSelectable ? Colors.transparent : kColor9,
        todayButtonColor: isTodayNotSelectable ? Colors.black45 : kColor9,
        selectedDayBorderColor: ctrl.isLoading ? kSecondaryColor : selectedDayButtonColor,
        selectedDayButtonColor: ctrl.isLoading ? kSecondaryColor : selectedDayButtonColor,
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
          color: ctrl.isLoading ? kTextColor1 : Colors.white,
        ),
        weekdayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kColor8,
        ),
        weekendTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
        multipleMarkedDates: ctrl.mx,
        iconColor: kPrimaryColor,
        daysHaveCircularBorder: false,
        thisMonthDayBorderColor: kSecondaryColor,
        selectedDateTime: ctrl.xdate,
        minSelectedDate: minDate,
        maxSelectedDate: widget.patientAppointment.packageExpDateTime == null ? now.add(const Duration(days: kMaxAppointmentDay)) : widget.patientAppointment.packageExpDateTime!,
        onDayPressed: (date, events) {
          String w = DateFormat('EEEE').format(date);
          bool b = ctrl.mx?.markedDates.any((o) => isSameDate(o.date, date)) ?? false;
          if (w != 'Sunday' && b == false) {
            ctrl.setXDate(date);
          }
        },
        onCalendarChanged: (DateTime dt) {
          ctrl.setXDate(dt);
          load(dt, false);
        },
      ),
    );

    return calendarCarousel;
  } */

  Widget buildLabels() {
    return Row(
      children: [
        Container(
          width: 16.0,
          height: 16.0,
          color: kColor9,
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
          color: kPrimaryColor,
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
          color: kColor19,
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
        const SizedBox(width: 10.0),
        Container(
          width: 16.0,
          height: 16.0,
          color: Colors.black45,
        ),
        const SizedBox(width: 8.0),
        Text(
          'Not Available',
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
                              border: Border.all(color: kPrimaryColor2),
                            ),
                            child: Center(
                              child: Text(
                                '1',
                                style: kTextStyle1.copyWith(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        afterLineStyle: const LineStyle(
                          color: kColor3,
                          thickness: 1,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Reselect Date',
                            style: kTextStyle1.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor2,
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
                              color: kColor12.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: kColor3),
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
                          color: kColor3,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                      child: Material(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Which date do you prefer?',
                              style: kTextStyle1.copyWith(
                                fontFamily: kFont2,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor3,
                              ),
                            ),
                            // const SizedBox(height: 24.0),
                            // const SizedBox(height: 27.0),
                            buildCalendar(),
                            const SizedBox(height: 16.0),
                            buildLabels(),
                            const SizedBox(height: 16.0),
                            /* Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: kBgColor2.withValues(alpha: 0.1),
                                    offset: const Offset(0.0, 4.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/icon/info1.png',
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
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), */
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
                  onPressed: ctrl.xdate == null ? null : onNext,
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
