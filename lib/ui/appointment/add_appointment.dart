import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart' show DateFormat;
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'appointment_free_slot.dart';

class AddAppointment extends StatefulWidget {

  static const String routeName = 'AddAppointment';

  final DoctorInfo? doctorInfo;

  const AddAppointment({
    super.key, 
    this.doctorInfo,
  });

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  String? selectedDoctorMcr;
  String selectedSpecialtyCode = '';
  String selectedSpecialtyName = '';
  String? selectedDoctorName = 'Select Doctor';
  String selectedCaseType = 'New Case';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    setState(() {
      selectedDate = getMinDate();
    });

    if (widget.doctorInfo != null) {
      final o = widget.doctorInfo;
      var doctorSpecialty = o?.doctorSpecialty ?? [];
      var specialty = doctorSpecialty.isEmpty ? null : doctorSpecialty.first.specialty;
      setState(() {
        selectedDoctorMcr = o?.mcr;
        selectedDoctorName = o?.name;
        if (specialty != null) {
          selectedSpecialtyCode = specialty.specialtyCode!;
          selectedSpecialtyName = specialty.specialtyDesc!;
        }
      });
    }
  }

  String getSelectedTime() {
    String s = 'Select Time';

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
      final format = DateFormat.jm();  //"6:00 AM"
      s = format.format(dt);
    }

    return s;
  }

  String getSelectedCaseType() {
    String s = 'NC';

    if (selectedCaseType == 'Follow-up') {
      s = 'FU';
    }

    return s;
  }

  bool get shouldDisableCheckAvailability {
    bool b = false;
    if (selectedDate == null || selectedSpecialtyCode == '') {
      b = true;
    }

    return b;
  }

  void onCheckAvailability() async {
    final formatDate = DateFormat('d-MMM-y');
    String dts = '06:00';
    final dlg = CustomDialog.of(context);

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
      'startDate': formatDate.format(selectedDate!),
      'startTime': dts,
    };
    try {
      setState(() {
        isLoading = true;
      });
      final nav = Navigator.of(context);
      var branchDetails = DataManager.branchDetails;
      var lx = await getVesaliusNextAvailableSlot(branchDetails!.branch!.branchId!, branchDetails.prn!, m);
      setState(() {
        isLoading = false;
      });
      if (lx.isEmpty) {
        dlg.showCustomDialog('Failed', 'There is no available slot on your request date / time.', 'Dismiss');
      }

      else {
        nav.push(
          MaterialPageRoute(
            builder: (context) => AppointmentFreeSlot(
              selectedDate: selectedDate,
              selectedTime: selectedTime,
              selectedDoctorName: selectedDoctorName,
              selectedSpecialtyName: selectedSpecialtyName,
              selectedCaseType: getSelectedCaseType(),
              isUpdate: false,
              list: lx,
            ),
          )
        );
      }
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.showCustomDialog('Failed', 'Sorry, no appointment slots available based on the selection criteria. Please reset and search again.', 'Dismiss');
    }
  }

  void showVisitTypes() async {
    String currCaseType = selectedCaseType;
    String? s = await showCupertinoDialog(
      context: context, 
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: const Text(
            'Type of Visit',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: kBodyFont,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 15.0),
                width: double.infinity,
                height: 1.0,
                color: const Color(0xFFE0E0E0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          currCaseType = 'New Case';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'New Case',
                              style: TextStyle(
                                color: currCaseType == 'New Case' ? kPrimaryColor : Colors.black,
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          currCaseType == 'New Case' ?
                          const Icon(
                            Icons.check,
                            color: kPrimaryColor,
                            size: 24.0,
                          ) :
                          const SizedBox(width: 24.0, height: 24.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          currCaseType = 'Follow-up';
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Follow-up',
                              style: TextStyle(
                                color: currCaseType == 'Follow-up' ? kPrimaryColor : Colors.black,
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          currCaseType == 'Follow-up' ?
                          const Icon(
                            Icons.check,
                            color: kPrimaryColor,
                            size: 24.0,
                          ) :
                          const SizedBox(width: 24.0, height: 24.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            CupertinoButton(
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                ),
              ), 
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoButton(
              child: const Text(
                'Okay',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              onPressed: () => Navigator.of(context).pop(currCaseType),
            ),
          ],
        ),
      ),
    );
    if (s != null) {
      setState(() {
        selectedCaseType = s;
      });
    }
  }

  void showVisitTypesBak() async {
    String currCaseType = selectedCaseType;
    String? s = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.only(top: 24.0, bottom: 0),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Type of Visit',
                        style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      color: const Color(0xFFE0E0E0),
                    ),

                    const SizedBox(height: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currCaseType = 'New Case';
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Case',
                                  style: TextStyle(
                                    color: currCaseType == 'New Case' ? kPrimaryColor : Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                                currCaseType == 'New Case' ?
                                const Icon(
                                  Icons.check,
                                  color: kPrimaryColor,
                                  size: 24.0,
                                ) :
                                const SizedBox(width: 24.0, height: 24.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currCaseType = 'Follow-up';
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Follow-up',
                                  style: TextStyle(
                                    color: currCaseType == 'Follow-up' ? kPrimaryColor : Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                                currCaseType == 'Follow-up' ?
                                const Icon(
                                  Icons.check,
                                  color: kPrimaryColor,
                                  size: 24.0,
                                ) :
                                const SizedBox(width: 24.0, height: 24.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),

                    Container(
                      height: 1.0,
                      color: const Color(0xFFE0E0E0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Dismiss',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 19.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1.0,
                          height: 50.0,
                          color: const Color(0xFFE0E0E0),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(currCaseType);
                            },
                            child: const Text(
                              'Okay',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
    if (s != null) {
      setState(() {
        selectedCaseType = s;
      });
    }
  }

  DateTime getMinDate() {
    DateTime today = DateTime.now();
    String tw = DateFormat('EEEE').format(today);
    DateTime dt = today.add(const Duration(days: 3));
    if (tw == 'Friday' || tw == 'Saturday') {
      dt = today.add(const Duration(days: 4)); // skip Sunday
    }

    final minDate = DateTime(dt.year, dt.month, dt.day);
    return minDate;
  }

  CalendarCarousel<Event> getCalendar() {
    final minDate = getMinDate();
    List<MarkedDate> ld = [];
    ld.addAll(
      [
        MarkedDate(textStyle: const TextStyle(color: Colors.white), color: const Color(0xFFFF5050), date: DateTime(2022, 1, 24)),
        MarkedDate(textStyle: const TextStyle(color: Colors.white), color: const Color(0xFFFF5050), date: DateTime(2022, 1, 26)),
      ]
    );
    MultipleMarkedDates mx = MultipleMarkedDates(markedDates: ld);

    final calendarCarousel = CalendarCarousel<Event>(
      height: 420.0,
      multipleMarkedDates: mx,
      prevDaysTextStyle: const TextStyle(color: Color(0xFFC0BFBF)),
      headerTextStyle: const TextStyle(
        fontSize: 16.0,
        fontFamily: kBodyFont,
        color: Color(0xFFA41D2A),
      ),
      selectedDayBorderColor: kAppointmentBgColor,
      selectedDayButtonColor: const Color(0xFF002E50),
      dayButtonColor: const Color(0xFFE1EDFF),
      daysTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        color: Color(0xFF4E4E4E),
      ),
      todayButtonColor: const Color(0xFF44A1E4),
      todayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        color: Colors.white,
      ),
      selectedDayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
        color: Colors.white,
      ),
      weekdayTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      weekendTextStyle: const TextStyle(
        fontFamily: kBodyFont,
      ),
      iconColor: const Color(0xFFA41D2A),
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

  void onSelectTime() async {
    var mselectedTime = await showTimePicker(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kAppointmentBgColor),
        backgroundColor: kAppointmentBgColor,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Make Appointment',
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
              Navigator.of(context).pop();
            }
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: isLoading ? Container() : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Container(
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Specialty',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                selectedSpecialtyName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /* Padding(
                        padding: EdgeInsets.only(right: 10.0, top: 20.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xFF8C8C8C),
                          size: 32.0,
                        ),
                      ), */
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Container(
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Doctor Name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                selectedDoctorName ?? '',
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
                      ),
                      /* Padding(
                        padding: EdgeInsets.only(right: 10.0, top: 20.0),
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xFF8C8C8C),
                          size: 32.0,
                        ),
                      ), */
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showVisitTypes();
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: AssetImage('images/icon/visit-0.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Type of Visit',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: kBodyFont,
                                    color: Color(0xFF8C8C8C),
                                  ),
                                ),
                                Text(
                                  selectedCaseType,
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
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0, top: 20.0),
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

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 20.0),
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
                          padding: EdgeInsets.only(left: 25.0, right: 15.0),
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
                                'Time',
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

                  // Padding(
                  //   padding: EdgeInsets.only(top: 30.0, bottom: 30.0, right: 15.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       SizedBox(
                  //         height: 40.0,
                  //         child: OutlinedButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               selectedCaseType = 'New Case';
                  //               selectedDate = null;
                  //               selectedTime = null;
                  //             });
                  //           },
                  //           child: Text(
                  //             'Reset',
                  //             style: TextStyle(
                  //               fontSize: 16.0,
                  //               color: kAppointmentBgColor,
                  //             ),
                  //           ),
                  //           style: OutlinedButton.styleFrom(
                  //             primary: kAppointmentBgColor,
                  //             backgroundColor: Colors.white,
                  //             side: BorderSide(
                  //               color: kAppointmentBgColor,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       //SizedBox(width: 20.0),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
                    child: RawMaterialButton(
                      elevation: 5.0,
                      fillColor: kAppointmentBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                      onPressed: shouldDisableCheckAvailability ? null : () {
                        onCheckAvailability();
                      },
                      child: const Text(
                        'Check Available Slot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
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
    );
  }
}