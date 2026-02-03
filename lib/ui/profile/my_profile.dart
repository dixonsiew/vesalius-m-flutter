import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/profile/my_profile_ctrl.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';

class MyProfile extends StatefulWidget {

  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  ScrollController scr = ScrollController();
  final MyProfileCtrl ctrl = Get.put(MyProfileCtrl());

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
    ctrl.setIsLoading(true);
    ctrl.setUserDetails(await DataManager.instance.getUserDetails());
    ctrl.setIsLoading(false);
  }

  Widget buildForm() {
    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          controller: scr,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 18.0),
            Text(
              'Full Name',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                '${ctrl.user?.firstName} ${ctrl.user?.middleName ?? ''} ${ctrl.user?.lastName ?? ''}'.trim(),
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'PRN',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                ctrl.user?.prn ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Date of Birth',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                ctrl.user?.dob?.replaceAll('-', ' ') ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Gender',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFC7CCD6)),
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Text(
                          ctrl.user?.sex ?? '',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Race',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color(0xFFC7CCD6)),
                          boxShadow: [
                            BoxShadow(
                              color: kBgColor2.withValues(alpha: 0.1),
                              offset: const Offset(0.0, 4.0),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Text(
                          ctrl.user?.race ?? '-',
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22.0),

            Text(
              'Nationality',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                ctrl.user?.nationality ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Email',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                ctrl.user?.email ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Contact Number',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                ctrl.user?.contactNo ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Address',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                ctrl.user?.address ?? '',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'My Profile',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}