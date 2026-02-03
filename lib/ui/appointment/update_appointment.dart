import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'appointment_free_slot.dart';

class UpdateAppointment extends StatefulWidget {

  static const String routeName = '/UpdateAppointment';

  final FutureAppointment appointment;

  const UpdateAppointment({
    Key? key, 
    required this.appointment
  }) : super(key: key);

  @override
  State<UpdateAppointment> createState() => _UpdateAppointmentState();
}

class _UpdateAppointmentState extends State<UpdateAppointment> {

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    if (widget.appointment.date != null && widget.appointment.date != '') {
      DateTime dt = DateFormat('d-MMM-y').parse(widget.appointment.date!);
      setState(() {
        selectedDate = dt;
      });
    }

    if (widget.appointment.startTime != null && widget.appointment.startTime != '') {
      List<String> a = widget.appointment.startTime!.split(':');
      int hour = int.parse(a[0]);
      int min = int.parse(a[1]);
      setState(() {
        selectedTime = TimeOfDay(hour: hour, minute: min);
      });
    }
  }

  String getDate() {
    if (selectedDate == null) {
      return 'NA';
    }

    final formatDate = DateFormat('d-MMM-y');
    return formatDate.format(selectedDate!);
  }

  String getSelectedTime() {
    String? s = widget.appointment.startTime;

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
      final format = DateFormat.jm();  //"6:00 AM"
      s = format.format(dt);
    }

    else {
      List<String> a = s!.split(':');
      int h = int.parse(a[0]);
      int m = int.parse(a[1]);
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, h, m);
      final format = DateFormat.jm();  //"6:00 AM"
      s = format.format(dt);
    }

    return s;
  }

  CalendarCarousel<Event> getCalendar() {
    DateTime today = DateTime.now();
    String tw = DateFormat('EEEE').format(today);
    DateTime dt = today.add(const Duration(days: 3));
    if (tw == 'Friday' || tw == 'Saturday') {
      dt = today.add(const Duration(days: 4)); // skip Sunday
    }

    final minDate = DateTime(dt.year, dt.month, dt.day);
    DateTime mminDate = minDate;

    if (selectedDate != null) {
      if (selectedDate!.isBefore(minDate)) {
        mminDate = selectedDate!;
      }
    }

    final calendarCarousel = CalendarCarousel<Event>(
      height: 420.0,
      headerTextStyle: const TextStyle(
        fontSize: 16.0,
        fontFamily: kBodyFont,
        color: Color(0xFF8C8C8C),
      ),
      selectedDayBorderColor: kAppointmentBgColor,
      selectedDayButtonColor: kAppointmentBgColor,
      daysTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        color: Colors.black,
      ),
      todayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      selectedDayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      weekdayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      weekendTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      iconColor: Colors.black,
      daysHaveCircularBorder: false,
      thisMonthDayBorderColor: const Color(0xFF8C8C8C),
      selectedDateTime: selectedDate ?? minDate,
      minSelectedDate: mminDate,
      onDayPressed: (date, events) {
        String w = DateFormat('EEEE').format(date);
        if (w != 'Sunday' && date.compareTo(minDate) >= 0) {
          setState(() {
            selectedDate = date;
          });
        }
      },
    );

    return calendarCarousel;
  }

  void onSelectTime() async {
    TimeOfDay? mselectedTime = await showTimePicker(
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: kAppointmentBgColor,
              ),
              timePickerTheme: TimePickerTheme.of(context).copyWith(
                helpTextStyle: const TextStyle(
                  fontFamily: kBodyFont,
                ),
                dayPeriodTextStyle: const TextStyle(
                  fontFamily: kBodyFont,
                ),
                hourMinuteTextStyle: const TextStyle(
                  fontSize: 50.0,
                  fontFamily: kBodyFont,
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

  void onCheckAvailability() async {
    final formatDate = DateFormat('d-MMM-y');
    String dts = '06:00';

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
      final formatTime = DateFormat.Hm();
      dts = formatTime.format(dt);
    }
    
    Map m = {
      'caseType': widget.appointment.caseType,
      'mcr': widget.appointment.doctorMcr,
      'specialtyCode': widget.appointment.specialtyCode,
      'startDate': formatDate.format(selectedDate!),
      'startTime': dts,
    };
    try {
      setState(() {
        isLoading = true;
      });
      UserBranch? branchDetails = DataManager.branchDetails;
      List<AvailableSlot> lx = await getVesaliusNextAvailableSlot(branchDetails!.branch!.branchId!, branchDetails.prn!, m);
      setState(() {
        isLoading = false;
      });
      if (lx.isEmpty) {
        showCustomDialog('Failed', 'There is no available slot on your request date / time.', 'Dismiss');
      }

      else {
        Get.to(() => AppointmentFreeSlot(
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          selectedDoctorName: widget.appointment.doctorName,
          selectedSpecialtyName: widget.appointment.specialty,
          selectedCaseType: widget.appointment.caseType,
          isUpdate: true,
          appointment: widget.appointment,
          list: lx,
        ));
      }
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kAppointmentBgColor),
        backgroundColor: kAppointmentBgColor,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Appointment Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            }
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage('images/icon/stethoscope-0.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 18.0),
                          child: Text(
                            'Specialty',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.appointment.specialty ?? '',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF808080),
                                ),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage('images/icon/md-0.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 18.0),
                          child: Text(
                            'Doctor Name',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.appointment.doctorName ?? '',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF808080),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 1.0,
                          color: const Color(0xFF8C8C8C),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            'Select a preferred date',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: const Color(0xFF8C8C8C),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: getCalendar(),
                  ),

                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 37.0, right: 15.0),
                        child: Icon(
                          Icons.event,
                          color: Color(0xFF8C8C8C),
                          size: 40.0,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reschedule Date',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                                color: Color(0xFF8C8C8C),
                              ),
                            ),
                            Text(
                              getDate(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8C8C8C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 25.0, bottom: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 1.0,
                          color: const Color(0xFF8C8C8C),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            'Select a preferred time',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: const Color(0xFF8C8C8C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onSelectTime();
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 37.0, right: 15.0),
                          child: Icon(
                            Icons.schedule_outlined,
                            color: Color(0xFF8C8C8C),
                            size: 40.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reschedule Time',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                getSelectedTime(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Color(0xFF8C8C8C),
                            size: 32.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
                    child: RawMaterialButton(
                      elevation: 5.0,
                      fillColor: kAppointmentBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                      child: const Text(
                        'Check Available Slot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
                        ),
                      ),
                      onPressed: () {
                        onCheckAvailability();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}