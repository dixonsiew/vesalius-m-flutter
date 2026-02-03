import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/appointment/reschedule_appointment.dart';

class AppointmentDetail extends StatefulWidget {
  
  static const String routeName = '/AppointmentDetail';

  const AppointmentDetail({super.key});

  @override
  State<AppointmentDetail> createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  bool isLoading = false;
  late final TextEditingController txtreason;

  @override
  void initState() {
    super.initState();
    txtreason = TextEditingController();
  }

  @override
  void dispose() {
    txtreason.dispose();
    super.dispose();
  }

  void onSubmitCancel(String s) async {
    showSuccessCancel();
  }

  void showSuccessCancel() async {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick1.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Appointment Cancel Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your appointment has been cancelled.',
              style: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor2),
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  Future<String> showCancel() async {
    return await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure want to cancel this appointment?',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                    color: kBgColor2.withOpacity(0.1),
                  ),
                ],
              ),
              child: TextField(
                controller: txtreason,
                cursorColor: kTextColor1,
                style: const TextStyle(
                  fontFamily: kBodyFont,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Share your reason with us',
                  hintStyle: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withOpacity(0.7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withOpacity(0.7)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Sure',
                    onPressed: () => Get.back(result: txtreason.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? '';
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return Stack(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 21.0),
                  color: kBgColor1,
                  child: Row(
                    children: [
                      Image.asset(
                        'images/imgs/pic1.png',
                        width: 64.0,
                        height: 64.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tan Sri Dato' Dr. Yahya Awang",
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Consultant Cardiothoracic Surgeon',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor4,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Image.asset(
                                'images/icon/location5.png',
                                width: 16.0,
                                height: 16.0,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'Room 212, Level 2',
                                style: kTextStyle1.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 1.0,
                  color: const Color(0xFFDBDBDB),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Patient',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFC7CCD6)),
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withOpacity(0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Text(
                          'Abu bin Ahmad',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Visit Type',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFC7CCD6)),
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withOpacity(0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Text(
                          'Follow Up',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Appointment Date & Time',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFC7CCD6)),
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withOpacity(0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/icon/clock3.png',
                              width: 16.0,
                              height: 16.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '11 Dec 2022, 3:30 PM',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 53.0),
                  child: Text(
                    '*Please ensure all the appointment details are correct before you proceed',
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor4,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppElevatedButton(
                    text: 'Reschedule',
                    onPressed: () {
                      Get.to(() => const RescheduleAppointment());
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppOutlinedButton(
                    text: 'Cancel Appointment',
                    onPressed: () async {
                      String s = await showCancel();
                      if (s.isNotEmpty) {
                        onSubmitCancel(s);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
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
      title: 'Appointment Details',
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const AppActivityIndicator(),
          child: buildContent(),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
