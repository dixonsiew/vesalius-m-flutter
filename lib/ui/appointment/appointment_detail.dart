import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24.0),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(25.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                              style: kMainTextStyle.copyWith(
                                fontFamily: kBodyFont,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Consultant Cardiothoracic Surgeon',
                              style: kBodyTextStyle.copyWith(
                                fontSize: 12.0,
                                color: const Color(0xFF8C8C8C),
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
                                  style: kBodyTextStyle.copyWith(
                                    fontSize: 12.0,
                                    color: kMainColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(
                      color: Color(0xFFE9E8E8),
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1EDFF),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(229, 229, 229, 0.1),
                            offset: Offset(0, 4.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/info.png',
                            width: 16.0,
                            height: 16.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10.0),
                          const Expanded(
                            child: Text(
                              'Need to reschedule / cancel appointment?\nCall Customer Service.',
                              style: kLabelTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Appointment Date & Time',
                      style: kLabelTextStyle.copyWith(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(235, 235, 235, 0.7),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(219, 219, 219, 0.65),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Text(
                        '01 Oct 2021, 9:00 AM',
                        style: kLabelTextStyle.copyWith(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Appointment Details',
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