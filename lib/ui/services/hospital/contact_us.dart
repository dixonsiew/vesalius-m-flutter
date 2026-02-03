import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/hospital/contact_us_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';

class ContactUs extends StatefulWidget {

  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  ScrollController scr = ScrollController();

  final ContactUsCtrl ctrl = Get.put(ContactUsCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final o = await CommonService.getHospitalInfo();
      ctrl.setData(o);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() :
    Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView(
          controller: scr,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16.0),
            const SizedBox(height: 18.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/imgs/hospital/address_icon.png',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    launchMap(5.42218, 100.31378);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 18.0),
                      Text(
                        'Address',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ctrl.data?.companyName ?? 'Metro Kurnia Sdn Bhd',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ctrl.data?.reg ?? '199201012255',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ctrl.data?.addr1 ?? 'No 1, Lorong Metro,',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${ctrl.data?.postcode ?? '08000'} ${ctrl.data?.addr2 ?? 'Sungai Petani,'}',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${ctrl.data?.state ?? 'Kedah,'} ${ctrl.data?.country ?? 'Malaysia'}',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            const SizedBox(height: 18.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/imgs/hospital/phone_icon.png',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 18.0),
                    Text(
                      'Contact',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Information and appointment',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        makePhoneCallNum(ctrl.data?.contactInfoApptCall ?? '+6044238888');
                      },
                      child: Text(
                        ctrl.data?.contactInfoApptDisplay ?? '+6604-4238888',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '24-hour Emergency Hotline',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        makePhoneCallNum(ctrl.data?.contact24Call ?? '+6044238888');
                      },
                      child: Text(
                        ctrl.data?.contact24Display ?? '+6044238888',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    /*
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/imgs/hospital/MY_icon.png',
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Toll-free in Malaysia',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                makePhoneCallNum(ctrl.data?.contactTollFreeMalCall ?? '1300880788');
                              },
                              child: Text(
                                ctrl.data?.contactTollFreeMalDisplay ?? '1300 880 788',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'images/imgs/hospital/IN_icon.png',
                            width: 36.0,
                            height: 36.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Toll-free in Indonesia',
                              style: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                makePhoneCallNum(ctrl.data?.contactTollFreeIndCall ?? '0078036015248');
                              },
                              child: Text(
                                ctrl.data?.contactTollFreeIndDisplay ?? '007 803 601 5248',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                     */
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              children: [
                Container(
                  width: 65.0,
                  height: 65.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/imgs/hospital/email_icon.png',
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMail(ctrl.data?.email ?? 'metro@hospitalmetro.com');
                      },
                      child: Text(
                        ctrl.data?.email ?? 'metro@hospitalmetro.com',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Contact Us',
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}