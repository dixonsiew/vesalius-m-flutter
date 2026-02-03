import 'package:flutter/material.dart';
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
import 'package:vesalius_m_flutter/ui/appointment.dart';
import 'package:vesalius_m_flutter/ui/home.dart';

class ConfirmAppointment extends StatefulWidget {
  
  static const String routeName = 'ConfirmAppointment';

  final String? selectedDate;
  final String? selectedTime;
  final String? selectedSpecialtyName;
  final String? selectedDoctorName;
  final String? selectedCaseType;
  final String? slotNumber;
  final bool isUpdate;
  final FutureAppointment? appointment;

  ConfirmAppointment({
    this.selectedDate,
    this.selectedTime,
    this.selectedSpecialtyName,
    this.selectedDoctorName,
    this.selectedCaseType,
    this.slotNumber,
    this.isUpdate = false,
    this.appointment,
  });

  @override
  _ConfirmAppointmentState createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {

  bool isLoading = false;

  void updateAppointment(BuildContext context) async {
    final s = await showConfirmDialogWithInput('Confirm Change Appointment', 'Are you sure you want to make change this appointment?', 'Cancel', 'Sure', 'Reason', context);
    try {
      if (s == null) {
        return;
      }

      var branchDetails = DataManager.branchDetails;
      var data = {
        'appointmentNumber': widget.appointment!.appointmentNumber!,
        'reason': s,
        'slotNumber': widget.slotNumber!,
      };
      await postVesaliusChangeAppointment(branchDetails!.branch!.branchId!, branchDetails.prn!, data);
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
      setState(() {
        isLoading = false;
      });
      await showCustomDialog('Successful', 'Your appointment has been rescheduled', 'Dismiss', context);
      Navigator.pushNamedAndRemoveUntil(context, Appointment.routeName, (route) {
        if (route.settings.name == Home.routeName) {
          return true;
        }

        return false;
      });
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog('Failed', 'Unable to update appointment information at the moment. Please check your internet connection or try again later.', 'Dismiss', context);
    }
  }

  void makeAppointment(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;
      var data = {
        'branchId': branchDetails!.branch!.branchId!,
        'caseType': widget.selectedCaseType,
        'slotNumber': widget.slotNumber,
      };
      await postVesaliusMakeAppointment(branchDetails.prn!, data);
      await AppointmentManager.getValidAppointment(branchDetails.branch!.branchId!);
      setState(() {
        isLoading = false;
      });
      await showCustomDialog('Successful', 'Appointment Created', 'Dismiss', context);
      Navigator.pushNamedAndRemoveUntil(context, Appointment.routeName, (route) {
        if (route.settings.name == Home.routeName) {
          return true;
        }

        return false;
      });
    }

    catch (error) {
      showCustomDialog('Failed', 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', 'Dismiss', context);
    }
  }

  void onConfirmAppointment(BuildContext context) async {
    if (!widget.isUpdate) {
      makeAppointment(context);
    }

    else {
      updateAppointment(context);
    }
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
          'Confirm Appointment',
          style: TextStyle(
            color: Color(0xFF565758),
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.selectedDate ?? '',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF808080),
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
                              fontSize: 16.0,
                              fontFamily: kBodyFont,
                              color: Color(0xFFB3B3B3),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.selectedTime ?? '',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: kBodyFont,
                                  color: Color(0xFF808080),
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
                                  widget.selectedSpecialtyName ?? '',
                                  style: TextStyle(
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
                                  widget.selectedDoctorName ?? '',
                                  style: TextStyle(
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
                        fontSize: 16.0,
                        fontFamily: kBodyFont,
                        color: Color.fromARGB(255, 88, 88, 88),
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
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: kBodyFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        onConfirmAppointment(context);
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