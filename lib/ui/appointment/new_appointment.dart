import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/appointment/step.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

import 'new_appointment_2.dart';

class NewAppointment extends StatefulWidget {
  
  static const String routeName = '/NewAppointment';

  final DoctorInfo? doctorInfo;

  const NewAppointment({
    Key? key, 
    required this.doctorInfo,
  }) : super(key: key);

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {

  String selectedCaseType = '';
  bool isLoading = false;

  void onNext() {
    Get.to(() => NewAppointment2(
      selectedCaseType: selectedCaseType,
      doctorInfo: widget.doctorInfo,
    ));
  }

  Widget buildStep1() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              thickness: 1.0,
              color: Color(0xFFC4C4C4),
            ),
          ),
          AppStep.buildStep(1),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        Scrollbar(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 72.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),
                    Text(
                      'Which type is your visit?',
                      style: kTitleTextStyle.copyWith(
                        fontSize: 22.0,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedCaseType = 'New Case';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: selectedCaseType == 'New Case' ? const Color(0xFFE7FDFF) : Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: selectedCaseType == 'New Case' ? kMainColor : const Color(0xFFADADAD),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(219, 219, 219, 0.6),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'New Case',
                                style: kTitleTextStyle.copyWith(
                                  fontSize: 16.0,
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
                    const SizedBox(height: 30.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedCaseType = 'Follow-up';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: selectedCaseType == 'Follow-up' ? const Color(0xFFE7FDFF) : Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: selectedCaseType == 'Follow-up' ? kMainColor : const Color(0xFFADADAD),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(219, 219, 219, 0.6),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Follow Up',
                                style: kTitleTextStyle.copyWith(
                                  fontSize: 16.0,
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
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            color: const Color(0xFFF8F8F8),
            child: buildStep1(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 42.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: selectedCaseType == '' ? null : onNext,
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: kMainColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  ),
                  child: Text(
                    'Next',
                    style: kMainTextStyle.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kMainColor,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    side: const BorderSide(
                      color: Color(0xFFDBDBDB),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: kMainTextStyle.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kMainColor,
                    ),
                  ),
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
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Make An Appointment',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: buildContent(),
        ),
      ),
    );
  }
}