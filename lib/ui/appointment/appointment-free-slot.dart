import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment-data.dart';
import 'confirm-appointment.dart';

class AppointmentFreeSlot extends StatefulWidget {
  
  static const String routeName = 'AppointmentFreeSlot';

  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? selectedSpecialtyName;
  final String? selectedDoctorName;
  final String? selectedCaseType;
  final bool isUpdate;
  final FutureAppointment? appointment;
  final List<AvailableSlot>? list;

  AppointmentFreeSlot({
    this.selectedDate,
    this.selectedTime,
    this.selectedSpecialtyName,
    this.selectedDoctorName,
    this.selectedCaseType,
    this.isUpdate = false,
    this.appointment,
    this.list,
  });

  @override
  _AppointmentFreeSlotState createState() => _AppointmentFreeSlotState();
}

class _AppointmentFreeSlotState extends State<AppointmentFreeSlot> {

  String getSelectedDate() {
    String s = 'NA';
    final format = DateFormat('d MMM y');

    if (widget.selectedDate != null) {
      s = format.format(widget.selectedDate!);
    }

    return s;
  }

  String getSelectedTime() {
    String s = '';

    if (widget.selectedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, widget.selectedTime!.hour, widget.selectedTime!.minute);
      final format = DateFormat.jm();  //"6:00 AM"
      s = format.format(dt);
    }

    return s;
  }

  String getTime(String s) {
    var a = s.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  List<Widget> buildSlots() {
    List<Widget> lx = [
      Padding(
        padding: EdgeInsets.only(left: 15.0, bottom: 20.0),
        child: Text(
          'Available Slot',
          style: TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 16.0,
            fontFamily: kBodyFont,
          ),
        ),
      ),
    ];

    widget.list?.forEach((o) {
      final w = Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => ConfirmAppointment(
                  selectedDate: getDate(o.date!),
                  selectedTime: getTime(o.startTime!),
                  selectedSpecialtyName: widget.selectedSpecialtyName!,
                  selectedDoctorName: o.doctorName!,
                  selectedCaseType: widget.selectedCaseType!,
                  slotNumber: o.slotNumber!,
                  isUpdate: widget.isUpdate,
                  appointment: widget.appointment,
                ),
              )
            );
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20.0, right: 7.0, top: 15.0, bottom: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getDate(o.date!)} , ${getTime(o.startTime!)}',
                        // '15 Apr 2021 , 3.05 PM',
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 16.0,
                          fontFamily: kBodyFont,
                        ),
                      ),
                      Text(
                        '${o.doctorName}',
                        style: TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 16.0,
                          fontFamily: kBodyFont,
                        ),
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xFF8C8C8C),
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      );
      lx.add(w);
    });
    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kAppointmentBgColor),
        backgroundColor: kAppointmentBgColor,
        toolbarHeight: kAppToolbarHeight,
        leadingWidth: 100.0,
        leading: BackBtn(color: Color(0xFF565758)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Available slot',
          style: TextStyle(
            color: Color(0xFF565758),
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 32,
                          color: Color(0xFF808080),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          'Date',
                          style: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16.0,
                            fontFamily: kBodyFont,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              getSelectedDate(),
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 32,
                          color: Color(0xFF808080),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          'Time',
                          style: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16.0,
                            fontFamily: kBodyFont,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              getSelectedTime(),
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 16.0,
                                fontFamily: kBodyFont,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/stethoscope-0.png',
                          width: 32.0,
                          height: 32.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 18.0),
                          child: Text(
                            'Specialty',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.selectedSpecialtyName!,
                                style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
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
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/md-0.png',
                          width: 32.0,
                          height: 32.0,
                          fit: BoxFit.contain,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 18.0),
                          child: Text(
                            'Doctor Name',
                            style: TextStyle(
                              color: Color(0xFFB3B3B3),
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.selectedDoctorName!,
                                style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                ),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildSlots(),
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