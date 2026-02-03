import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment-data.dart';
import 'package:vesalius_m_flutter/models/appointment-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';
import 'update-appointment.dart';

class EditAppointment extends StatefulWidget {
  
  static const String routeName = 'EditAppointment';

  final FutureAppointment appointment;

  EditAppointment({
    required this.appointment,
  });

  @override
  _EditAppointmentState createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {

  bool isLoading = false;

  void onDeleteAppointment() async {
    final s = await showConfirmDialogWithInput('Confirm to Delete', 'Are you sure you want to delete this appointment?', 'Cancel', 'Sure', 'Reason', context);
    try {
      if (s == null) {
        return;
      }

      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      await postVesaliusCancelAppointment(branchDetails!.branch!.branchId!, branchDetails.prn!, {
        'appointmentNumber': widget.appointment.appointmentNumber,
        'reason': s,
      });
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, true);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Failed', 'Unable to delete appointment at the moment. Please check your internet connection or try again later.', 'Dismiss', context);
    }
  }

  String getTime(String s) {
    var a = s.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [h, ':', nn, ' ', am]);
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Color(0xFF565758),
            ),
            onPressed: () {
              onDeleteAppointment();
            }
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
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
                                getDate(widget.appointment.date!),
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
                                getTime(widget.appointment.startTime!),
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
                                  widget.appointment.specialty!,
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
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
                                  widget.appointment.doctorName!,
                                  style: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 16.0,
                                    fontFamily: kBodyFont,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text(
                      '*Please ensure all the appointment details are correct before you proceed',
                      style: TextStyle(
                        color: Color.fromARGB(255, 88, 88, 88),
                        fontSize: 16.0,
                        fontFamily: kBodyFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: RawMaterialButton(
                      elevation: 5.0,
                      fillColor: kHomeBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => UpdateAppointment(appointment: widget.appointment),
                          )
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}