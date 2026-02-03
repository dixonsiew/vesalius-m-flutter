import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart' show DateFormat;
import 'package:vesalius_m_flutter/components/app-shared.dart';

import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/doctor-data.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

import 'appointment-free-slot.dart';

class AddAppointment extends StatefulWidget {

  static final String routeName = 'AddAppointment';

  final DoctorInfo doctorInfo;

  AddAppointment({
    this.doctorInfo,
  });

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {

  String selectedDoctorMcr;
  String selectedSpecialtyCode = '';
  String selectedSpecialtyName = '';
  String selectedDoctorName = 'Select Doctor';
  String selectedCaseType = 'New Case';
  DateTime selectedDate;
  TimeOfDay selectedTime;
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
      var doctorSpecialty = o.doctorSpecialty ?? [];
      var specialty = doctorSpecialty.isEmpty ? null : doctorSpecialty.first.specialty;
      setState(() {
        selectedDoctorMcr = o.mcr;
        selectedDoctorName = o.name;
        if (specialty != null) {
          selectedSpecialtyCode = specialty.specialtyCode;
          selectedSpecialtyName = specialty.specialtyDesc;
        }
      });
    }
  }

  String getSelectedTime() {
    String s = 'Select Time';

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
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

    if (selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
      final formatTime = DateFormat.Hm();
      dts = formatTime.format(dt);
    }
    
    Map m = {
      'caseType': getSelectedCaseType(),
      'mcr': selectedDoctorMcr,
      'specialtyCode': selectedSpecialtyCode,
      'startDate': formatDate.format(selectedDate),
      'startTime': dts,
    };
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      var lx = await getVesaliusNextAvailableSlot(branchDetails.branch.branchId, branchDetails.prn, m) ?? [];
      setState(() {
        isLoading = false;
      });
      if (lx.isEmpty) {
        showCustomDialog('Failed', 'There is no available slot on your request date / time.', 'Dismiss', context);
      }

      else {
        Navigator.push(context,
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
      showCustomDialog('Failed', 'Sorry, no appointment slots available based on the selection criteria. Please reset and search again.', 'Dismiss', context);
    }
  }

  void showVisitTypes() async {
    String currCaseType = selectedCaseType;
    String s = await showCupertinoDialog(
      context: context, 
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => CupertinoAlertDialog(
          title: Text(
            'Type of Visit',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                width: double.infinity,
                height: 1.0,
                color: Color(0xFFE0E0E0),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          currCaseType == 'New Case' ?
                          Icon(
                            Icons.check,
                            color: kPrimaryColor,
                            size: 24.0,
                          ) :
                          Container(width: 24.0, height: 24.0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
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
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          currCaseType == 'Follow-up' ?
                          Icon(
                            Icons.check,
                            color: kPrimaryColor,
                            size: 24.0,
                          ) :
                          Container(width: 24.0, height: 24.0),
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
              child: Text(
                'Dismiss',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                ),
              ), 
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoButton(
              child: Text(
                'Okay',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              onPressed: () => Navigator.pop(context, currCaseType),
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
    String s = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.only(top: 24.0, bottom: 0),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Type of Visit',
                        style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Color(0xFFE0E0E0),
                    ),

                    SizedBox(height: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                Icon(
                                  Icons.check,
                                  color: kPrimaryColor,
                                  size: 24.0,
                                ) :
                                SizedBox(width: 24.0, height: 24.0),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                Icon(
                                  Icons.check,
                                  color: kPrimaryColor,
                                  size: 24.0,
                                ) :
                                SizedBox(width: 24.0, height: 24.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),

                    Container(
                      height: 1.0,
                      color: Color(0xFFE0E0E0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
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
                          color: Color(0xFFE0E0E0),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, currCaseType);
                            },
                            child: Text(
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
    DateTime dt = today.add(Duration(days: 3));
    if (tw == 'Friday' || tw == 'Saturday') {
      dt = today.add(Duration(days: 4)); // skip Sunday
    }

    final minDate = DateTime(dt.year, dt.month, dt.day);
    return minDate;
  }

  CalendarCarousel<Event> getCalendar() {
    final minDate = getMinDate();

    final calendarCarousel = CalendarCarousel<Event>(
      height: 420.0,
      headerTextStyle: TextStyle(
        fontSize: 16.0,
        color: Color(0xFF8C8C8C),
      ),
      iconColor: Colors.black,
      daysHaveCircularBorder: false,
      thisMonthDayBorderColor: Color(0xFF8C8C8C),
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
    var _selectedTime = await showTimePicker(
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: kPrimaryColor,
              ),
            ),
            child: child,
          ),
        );
      }
    );
    if (_selectedTime != null) {
      setState(() {
        selectedTime = _selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: kAppointmentBgColor,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Make Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: isLoading ? Container() : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
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
                          padding: EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Specialty',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                selectedSpecialtyName,
                                style: TextStyle(
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
                        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
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
                          padding: EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doctor Name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                selectedDoctorName,
                                style: TextStyle(
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
                  InkWell(
                    onTap: () {
                      showVisitTypes();
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
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
                            padding: EdgeInsets.only(top: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type of Visit',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF8C8C8C),
                                  ),
                                ),
                                Text(
                                  selectedCaseType,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8C8C8C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
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
                    padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 1.0,
                          color: Color(0xFF8C8C8C),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            'Select a preferred date',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: getCalendar(),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 25.0,
                          height: 1.0,
                          color: Color(0xFF8C8C8C),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            'Select a preferred time',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.0,
                            color: Color(0xFF8C8C8C),
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
                        Padding(
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
                              Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                              Text(
                                getSelectedTime(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8C8C8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
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
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 15.0),
                    child: RawMaterialButton(
                      elevation: 5.0,
                      fillColor: kAppointmentBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                      child: Text(
                        'Check Available Slot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: shouldDisableCheckAvailability ? null : () {
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