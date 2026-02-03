import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class AppointmentDetail extends StatefulWidget {
  
  static const String routeName = '/AppointmentDetail';

  const AppointmentDetail({Key? key}) : super(key: key);

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
      contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: Column(
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
              color: kTextColor2
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              backgroundColor: kMainColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            ),
            child: Text(
              'Done',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<String> cancelAppointment() async {
    return await Get.dialog(AlertDialog(
      contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: Column(
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
              border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.7)),
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
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTextColor2,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    side: const BorderSide(
                      color: Color(0xFFDBDBDB),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(result: txtreason.text);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: kMainColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  ),
                  child: Text(
                    'Sure',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                'images/icon/location3.png',
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
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    color: Color(0xFFE9E8E8),
                    thickness: 1.0,
                  ),
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
                  child: ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: kMainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    ),
                    child: Text(
                      'Reschedule',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      String s = await cancelAppointment();
                      onSubmitCancel(s);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kTextColor2,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      side: const BorderSide(
                        color: Color(0xFFDBDBDB),
                      ),
                    ),
                    child: Text(
                      'Cancel Appointment',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24.0),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    
                  ],
                ),
              ),
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: kBgColor1,
        leading: const BackBtn(color: kTextColor1),
        centerTitle: true,
        title: Text(
          'Appointment Details',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: kBgColor1,
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