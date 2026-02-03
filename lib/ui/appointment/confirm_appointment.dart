import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
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

  const ConfirmAppointment({
    Key? key,
    this.selectedDate,
    this.selectedTime,
    this.selectedSpecialtyName,
    this.selectedDoctorName,
    this.selectedCaseType,
    this.slotNumber,
    this.isUpdate = false,
    this.appointment,
  }) : super(key: key);

  @override
  State<ConfirmAppointment> createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {

  bool isLoading = false;

  void updateAppointment(BuildContext context) async {
    CustomDialog dlg = CustomDialog.of(context);
    NavigatorState nav = Navigator.of(context);
    final s = await dlg.showConfirmDialogWithInput('Confirm Change Appointment', 'Are you sure you want to make change this appointment?', 'Cancel', 'Sure', 'Reason');
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
      await dlg.showCustomDialog('Successful', 'Your appointment has been rescheduled', 'Dismiss');
      nav.pushNamedAndRemoveUntil(Appointment.routeName, (route) {
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
      dlg.showCustomDialog('Failed', 'Unable to update appointment information at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void makeAppointment(BuildContext context) async {
    CustomDialog dlg = CustomDialog.of(context);

    try {
      setState(() {
        isLoading = true;
      });
      NavigatorState nav = Navigator.of(context);
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
      await dlg.showCustomDialog('Successful', 'Appointment Created', 'Dismiss');
      nav.pushNamedAndRemoveUntil(Appointment.routeName, (route) {
        if (route.settings.name == Home.routeName) {
          return true;
        }

        return false;
      });
    }

    catch (error) {
      dlg.showCustomDialog('Failed', 'Unable to create new appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kAppointmentBgColor),
        backgroundColor: kAppointmentBgColor,
        toolbarHeight: kAppToolbarHeight,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Color(0xFF565758)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
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
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Please wait...'),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event,
                            size: 32,
                            color: Color(0xFF808080),
                          ),
                          const SizedBox(width: 15.0),
                          const Text(
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
                                style: const TextStyle(
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
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 32,
                            color: Color(0xFF808080),
                          ),
                          const SizedBox(width: 15.0),
                          const Text(
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
                                style: const TextStyle(
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
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/stethoscope-0.png',
                            width: 32.0,
                            height: 32.0,
                            fit: BoxFit.contain,
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
                                  widget.selectedSpecialtyName ?? '',
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
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/md-0.png',
                            width: 32.0,
                            height: 32.0,
                            fit: BoxFit.contain,
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
                                  widget.selectedDoctorName ?? '',
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
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
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
                    padding: const EdgeInsets.all(15.0),
                    child: RawMaterialButton(
                      elevation: 5.0,
                      fillColor: kHomeBgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
                      child: const Text(
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