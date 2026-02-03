import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/auth_service.dart';
import 'package:vesalius_m_flutter/ui/app_start.dart';

final kTextStylex1 = kTextStyle1.copyWith(
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  color: kTextColor1,
);

final kTextStylex2 = kTextStyle1.copyWith(
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  color: kTextColor1,
);

class TnC extends StatefulWidget {

  const TnC({super.key});

  @override
  State<TnC> createState() => _TnCState();
}

class _TnCState extends State<TnC> {

  String deviceId = '';
  ScrollController scr = ScrollController();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final TncCtrl ctrl = Get.put(TncCtrl());

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
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }
    } on PlatformException catch (_) {}

    initPlatformState();
  }

  void initPlatformState() {
    // OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    // OneSignal.shared.setRequiresUserPrivacyConsent(false);

    // await OneSignal.shared.setAppId(kOneSignalAppID);
  }

  TextSpan longText(String s, [bool newLine = true]) {
    if (newLine) {
      return TextSpan(
        text: '$s\n',
        style: kTextStylex1,
      );
    }

    return TextSpan(
      text: s,
      style: kTextStylex1,
    );
  }

  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '''TERMS OF USE FOR METRO HOSPITAL SDN BHD’S MOBILE APPLICATION\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
Thank you for downloading Metro Hospital’s (the “Company”) Mobile Application (the “Application”). By downloading and using the Application, and by receiving services through the Application (“Services”), you agree to be bound by the terms of service set out below (the “Agreement”).
If you do not agree to all of the terms of this Agreement, you may electronically click “Disagree/Decline”. If you click “Disagree/Decline” you will not be able to access the Application. 
By using the Application, the you agree to verify the personal data, health care information and records relating to yourself. The accessibility and operation of the Application relies on third-party systems, databases and technologies outside the direct control of the Company. The Company cannot guarantee continuous accessibility or uninterrupted operation of the Application. The Company cannot be held liable to if, for any reason, access to the application is delayed or unavailable for any period of time. The company may amend and update the terms of this Agreement from time to time without notice and for any reason. Amendments will be effective upon the Application’s posting of such updated terms at this location or in the amended policies (if any) or supplemental terms (if any) on the applicable Service(s). Words denoting one gender shall include the other gender. Words denoting a singular number shall include the plural and vice versa.
'''
                  ),
                  TextSpan(
                    text: '''1. Registration and Membership\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1.1 ',
                        style: kTextStylex2,
                      ),
                      longText('''The Application is a platform that allows you to select and transmit a request for certain healthcare services, which include online appointment booking (collectively “Healthcare Services”).\n'''),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1.2 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
In order to access Healthcare Services personalised to you, you are required to be patient in Metro Hospital. Please ensure all the information within the Application are correct. By completing the Account information, you represent and warrant that all of the personal information provided are true and correct. You agree to maintain accurate, complete and up-to-date information in your Account. Failure to maintain accurate, complete and up-to-date Account information, may result in the inability to access or use the Healthcare Services. The Company reserves the right to refuse or cancel your Account or your use of the Application and/or the Services if you have not provided complete and accurate information regarding your identity and/or have not provided accurate health information and the failure to provide such accurate information amounts to a fundamental breach of this Agreement on your part.
'''                   ),
                    ],
                  ),
                  TextSpan(
                    text: '1.3 Patient Profile Verification\n\n',
                    style: kTextStylex2,
                  ),
                  longText(
'''
Upon the addition of a new patient profile, account verification will be performed. Verification against Metro Hospital’s database such as Full Name, NRIC / Passport, Date of Birth and email address will be performed.  A verification code will be sent via email to the registered email address. When the correct verification code is given by the user, the patient profile will be created.
'''               ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1.4 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
You agree that you will not choose or use a username that: (i) belongs to another person or with the intent of impersonating another person; or (ii) is subject to any rights of a person other than you without appropriate authorization. 
'''                   ),
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '1.5 ',
                            style: kTextStylex2,
                          ),
                          longText(
'''
DO NOT share your username and password with anyone. The Company will not be liable for any compromise to the security of your Account as a result of your failure to maintain confidentiality of your username and password.
'''
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextSpan(
                    text: '''2. Eligibility\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '2.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
You must be 18 years of age or older to use the Application and the Healthcare Services provided through the Application.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    text: '''3. Our Services\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    text: '''3.1 Online Appointment Booking\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
The application enables you to make appointments with doctors and/or other Healthcare Services at the Company. The Company cannot guarantee the availability of the Doctor at any particular time. The Doctor shall reserve the right to accept or decline any appointment made through the application.
The Company shall not be held liable for cancelled or unfulfilled appointments.
'''
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '3.1.1 ',
                        style: kTextStylex2,
                      ),
                      longText('''The Company reserves the sole and absolute right to:\n'''),
                    ],
                  ),
                  longText('''(a) add, amend and/ or vary our Application and Services at any time without assigning any reasons whatever and without any prior notice; and/or\n'''),
                  longText('''(b) suspend the operation of your account and/or terminate your account without assigning any reasons whatsoever and without any prior notice.\n'''),
                  TextSpan(
                    text: '''4. Internet Delays\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '4.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
You acknowledge that the Service and/or the Application may be subject to limitations, delays and other problems inherent in the use of the internet and electronic communications, including the device used by you or the healthcare professionals providing the Health Services. The company is not responsible for any delays, delivery failures, damages or losses resulting from such problems.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    text: '''5. Location Functionality\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '5.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Services include and make use of certain functionality and services provided by third party applications which may include maps, geocoding, places and other content. The Company disclaims any liability for the use of such third-party applications.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    text: '''6. License and Limitations on Use\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '6.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The company grants to you a limited, personal, non-exclusive and non-transferable right and license to use the Application and to access our Services using the Application. Unless otherwise specified in writing, the Application and Services are for your personal and non-commercial use. The Application, including, without limitation, the content, metadata, design, organization, compilation, look and feel, the fitness and nutrition plans, the source, object and HTML code and all other protectable intellectual property available through the Services and/or comprising the Application
(“Proprietary Materials”) are the property of the company and are protected by copyright and other intellectual property laws. All rights regarding the Proprietary Materials not expressly granted in this Agreement are reserved by the Company. The user may not copy, reproduce, sell, publish, distribute, display, retransmit or otherwise provide access to the Proprietary Materials to anyone. The user agrees not to rearrange, modify, create derivative works using or reverse engineer the Proprietary Materials. The user may not to post any content from the Application to weblogs, news groups, mail lists or electronic bulletin boards, without prior written consent of the Company.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '6.2 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
By using the Application or the Services, you agree that your use:
'''
                      ),
                    ],
                  ),
                  longText('''(a) Will be for lawful purposes only and never for sending or storing unlawful material or use for fraudulent purposes;\n'''),
                  longText('''(b) Will not cause any nuisance, annoyance, disruption, or inconvenience;\n'''),
                  longText('''(c) Will not impair the proper operation of the network;\n'''),
                  longText('''(d) Will only be through access points or wireless data account (AP) which you are authorized to use; and\n'''),
                  longText('''(e) May involve charges by your wireless provider.\n'''),
                  TextSpan(
                    text: '''7. User Conduct\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '7.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Company reserves the right to terminate your Account status if you misuse the Application, our Services, or if you violate this Agreement including, without limitation, the following rules of conduct:
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '7.2 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
You may not:
'''
                      ),
                    ],
                  ),
                  longText('''(a) Upload, post, or transmit by any means, or otherwise make available any content or materials that are unlawful, harmful, threatening, abusive, harassing, tortious, defamatory, vulgar, obscene, libellous, invasive of another’s privacy, hateful, or racially, ethnically or otherwise objectionable;\n'''),
                  longText('''(b) Impersonate any person or entity, or falsely state or otherwise misrepresent your affiliation with a person or entity;\n'''),
                  longText('''(c) Forge headers or otherwise manipulate identifiers in order to disguise the origin of any information transmitted;\n'''),
                  longText('''(d) Upload, post, email, or otherwise transmit through the Application by any means, content, materials, or comments that could be characterized as “medical advice;”\n'''),
                  longText('''(e) Attempt to interfere with or disrupt our servers or networks;\n'''),
                  longText('''(f) Intentionally or unintentionally violate any applicable local, state, national or international law or any regulations having the force of law;\n'''),
                  longText('''(g) Stalk or otherwise harass another user or any of our employees, or the healthcare professionals;\n'''),
                  longText(
'''
(h) Solicit, collect or post personal data or attempt to solicit, collect or post personal data about other users including usernames or passwords; or access or attempt to access another user’s account without his or her consent or, in the case of a minor, that of the minor’s parent or guardian or other responsible adult.
'''
                  ),
                  TextSpan(
                    text: '''8. Disclaimers of Warranties\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
Your use of the application is at your own risk. The Company expressly disclaims all representations and warranties about the accuracy, completeness, timeliness or efficacy of the content of the application, and assumes no liability or responsibility to you or any minor for whom you are responsible for any errors, mistakes, or inaccuracies in such content or in the services provided by any third party on the Application. You agree that your access to, and use of, the Application, is on an “as- is” and “as available” basis and the Application may not cover all information available on a particular issue, and the information may not always be accurate, complete or up-to-date. The information on the application is not intended to be a substitute for the advice of a medical professional. You should never disregard or delay in seeking professional medical advice because of something you have read on the application. All information contained in the application is for informational purposes only and is to be used at your own risk. We do not accept any responsibility for any reliance by you on the information contained in the application.
'''
                  ),
                  TextSpan(
                    text: '''9. Limitation of Liability\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '9.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
To the extent permitted under law, the Company excludes all conditions, warranties, representations, or other terms which may apply to the application, whether express or implied.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '9.2 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Company does not give any representations, warranties, guarantees, or any other commitments, or accept any liability, to you.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '9.3 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Company will not be liable for any loss or damage, whether in contract, tort (including negligence), breach of statutory duty, loss of revenue, loss of profits, or otherwise, even if foreseeable, arising from or in connection with:
'''
                      ),
                    ],
                  ),
                  longText('''a. any inaccuracy or incompleteness in, or errors or omissions in the information on the Application;\n'''),
                  longText('''b. you using, visiting or relying on any statements, opinion, representation or information in the Application;\n'''),
                  longText('''c. any delay in operation or transmission, communications failure, Internet access difficulties or malfunctions in equipment or software; and\n'''),
                  longText('''d. the conduct or the views of any person who accesses or uses the Application.\n'''),
                  TextSpan(
                    text: '''10. Use with Your Mobile Device\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
Use of these Services on a mobile device requires a compatible mobile device, internet access and an internet browser. You agree that you are solely responsible for these requirements, including any applicable changes, updates and fees as well as the terms of your agreement with your mobile device and telecommunications provider.
The Company makes no warranties or representations of any kind, express, statutory, or implied as to the availability of telecommunication services from your provider and access to the services at any time or from any location; any loss, damage, or other security intrusion of the telecommunication services;
or any disclosure of information to third parties; failure to transmit any data; communications; or settings connected with the Services.
'''
                  ),
                  TextSpan(
                    text: '''11. Indemnification.\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
You agree to defend, indemnify, and to hold harmless the Company with its respective affiliates, directors, officers, agents and employees, from any and all liabilities, penalties, claims, causes of action, and demands brought by third parties (including the costs, expenses and attorneys’ fees on account thereof) arising, resulting from or relating to:
'''    
                  ),
                  longText('''(a) your use or your inability to use the Application or Services; or\n'''),
                  longText(
'''
(b) an allegation that you violated any representation, warranty, covenant or condition in this Agreement. Your agreement to defend, to indemnify, and to hold the company (and its officers and directors) harmless applies regardless of the form of action, including but not limited to your violation of any third party right, a claim that the Application, Services caused damage to you or to any third party and/or your use and access to the Application and/or Services. In addition, you agree to indemnify, defend and hold harmless your Treating Provider(s) from and against any third-party claims resulting from your lack of adherence with the advice or recommendation(s) of such Treating Provider. This indemnification section shall survive your termination of or cessation of use of the Application and our Services.
'''
                  ),
                  TextSpan(
                    text: '''12. Waiver\n\n''',
                    style: kTextStylex2,
                  ),
                  longText('''Failure to insist that you perform any of your obligations under these Terms do not imply that the Company has waived its’ rights against you and will not mean that you do not have to comply with those obligations.\n'''),
                  TextSpan(
                    text: '''13. Business Uses of Our Services\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
If you are using our Services on behalf of a business, that business accepts these terms. It will hold harmless and indemnify the Company, with its respective directors, officers, affiliates, agents and employees from any claim, suit or action arising from or related to the use of the Services or violation of these terms, including any liability or expense arising from claims, losses, damages, suits, judgments, litigation costs and legal fees.
'''
                  ),
                  TextSpan(
                    text: '''14. Assignments\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
The Company may assign its rights and obligations under this Agreement. This Agreement will inure to the benefit of the Company’s successors, assigns and licensees. The failure of either party to insist upon or enforce the strict performance of the other party with respect to any provision of this Agreement, or to exercise any right under the Agreement, will not be construed as a waiver or relinquishment to any extent of such party’s right to assert or rely upon any such provision or right in that or any other instance; rather, the same will be and remain in full force and effect.
'''
                  ),
                  TextSpan(
                    text: '''15. Promotions and Offers\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
The Company may, as part of its’ services to users, encourage you to participate and enjoy our promotions. The following terms and conditions apply to all offers and promotions, unless otherwise stated. By
accepting any promotional offer, you agree to be bound by any additional terms set out in the promotional offer. The Company may use any personal information you provide to us (including your email address), to provide you (by email or otherwise) with information regarding contests and promotions, as further described in our Privacy Policy; provided, however, that the Company not use your personal information for promotions or for marketing of products without your prior consent.
The Company is not responsible for any unauthorized promotions and offers offered by third parties through the Application.
'''
                  ),
                  TextSpan(
                    text: '''16. Intellectual Property\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '16.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Company shall own all rights, titles and interest, including all related intellectual property rights, in the Application and to the website which includes all its contents, including without limitation the software, text, materials, compilation of information, images, videos, displays, audio and design and any suggestions, ideas, enhancement requests, feedback, recommendations or other information provided by you or any other party relating to the Service/Site.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '16.2 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Terms of Use does not constitute a sale agreement and does not convey to you any rights of ownership in or related to the Services or any intellectual property rights owned by the Company and/or its licensors. The Company name, the Company logo, and certain other material on the Site constitute trademarks or other intellectual property rights of the Company or its licensors/providers or other parties and no right or license is granted to use them. You must not reproduce, screenshot, distribute, modify, communicate to the public, download or transmit any of the material on this Site except as expressly permitted by these Terms of Use.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    text: '''17. Variation of Terms\n\n''',
                    style: kTextStylex2,
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '17.1 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Company may revise these Terms at any time by updating this page. You should visit this page from time to time to review the Terms because they are legally binding on you.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '17.2 ',
                        style: kTextStylex2,
                      ),
                      longText(
'''
The Company may modify or discontinue any features, services, tools, directories or content on the Application at any time, with or without notice, and without liability.
'''
                      ),
                    ],
                  ),
                  TextSpan(
                    text: '''18. Governing Law\n\n''',
                    style: kTextStylex2,
                  ),
                  longText('''You agree that these Terms of Use, as well as all claims arising will be governed by and construed in accordance with the laws of Malaysia.\n'''),
                  TextSpan(
                    text: '''19. Privacy & PDPA Consent Notice\n\n''',
                    style: kTextStylex2,
                  ),
                  longText(
'''
All information including your personal and sensitive data collected through the Application shall be processed in accordance to Metro Hospital Sdn Bhd’s privacy policy, which can be found at https://islandhospital.com/personal-data-protection-act.''', false
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Checkbox(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  activeColor: kPrimaryColor,
                  value: ctrl.isAgree,
                  onChanged: (value) {
                    ctrl.setIsAgree(true);
                  },
                ),
                Expanded(
                  child: Text(
                    'I have read and agree to the Terms & Conditions.',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() =>
              AppElevatedButton(
                onPressed: ctrl.isAgree == false ? null : () async {
                  await DataManager.instance.setItem('__accepttnc__', true);

                  if (AuthManager.instance.playerId != '') {
                    try { 
                      ctrl.setIsLoading(true);
                      await UserService.postPlayerID({
                        'playerId': AuthManager.instance.playerId,
                        'machineId': deviceId
                      });
                      ctrl.setIsLoading(false);
                    }
                    
                    catch (_) {
                      ctrl.setIsLoading(false);
                    }
                  }

                  Get.off(() => const AppStart());
                },
                text: 'Accept',
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
        toolbarHeight: kTextTabBarHeight,
        backgroundColor: kBgColor1,
        centerTitle: true,
        title: Text(
          'Terms & Conditions',
          style: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: kTextColor1,
          ),
        ),
        elevation: 2.0,
      ),
      backgroundColor: kBgColor1,
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

class TncCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isAgree = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsAgree(bool b) {
    _isAgree.value = b;
  }

  bool get isLoading => _isLoading.value;
  bool get isAgree => _isAgree.value;
}