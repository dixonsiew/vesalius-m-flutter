import 'package:barcode_widget/barcode_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'profile/change_password.dart';
import 'sign_in.dart';

class Profile extends StatefulWidget {

  static const String routeName = '/Profile';

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin<Profile> {

  bool isLoading = false;
  PatientDetails? patientDetails;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    UserBranch? branchDetails = DataManager.branchDetails;
    try {
      setState(() {
        isLoading = true;
      });
      PatientDetails? patientData = await getVesaliusPatientData(branchDetails!.branch!.branchId!, branchDetails.prn!);
      await DataManager.setPatientDetails(patientData);
      setState(() {
        patientDetails = patientData;
        isLoading = false;
      });
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> onSignOut() async {
    return await showConfirmDialog('Are you sure you want to sign out?');
  }

  Widget buildBackCard() {
    String s = '';
    if (patientDetails != null) {
      s = patientDetails!.prn!;
    }

    return Stack(
      children: [
        Container(
          width: 300.0,
          height: 200.0,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage('images/imgs/cardb.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: QrImage(
                        data: s,
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: BarcodeWidget(
                      barcode: Barcode.code128(), // Barcode type and settings
                      data: s, // Content
                      width: 105.0,
                      height: 60.0,
                      style: kBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFrontCard() {
    String s = '';
    if (patientDetails != null) {
      Name name = patientDetails!.name!;
      s = '${name.title} ${name.firstName} ${name.middleName} ${name.lastName}';
    }

    return Stack(
      children: [
        Container(
          width: 300.0,
          height: 200.0,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage('images/imgs/card.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 280.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 85.0, left: 20.0, right: 20.0),
                    child: Text(
                      'PRN:',
                      style: kBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 85.0),
                    child: Text(
                      patientDetails == null ? '' : patientDetails!.prn!,
                      style: kBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Text(
                      'Name:',
                      style: kBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s,
                      style: kBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    if (patientDetails == null) {
      return Container();
    }

    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 45.0),
          child: Text(
            'Profile',
            style: kMainTextStyle.copyWith(
              fontSize: 24.0,
              color: kMainColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 37.0, right: 37.0, top: 21.0),
          child: Align(
            alignment: Alignment.center,
            child: FlipCard(
              front: buildFrontCard(),
              back: buildBackCard(),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Align(
          alignment: Alignment.center,
          child: Text(
            'Tap to flip the card',
            style: kBodyTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB1B1B1),
            ),
          ),
        ),
        Padding(
          padding:const EdgeInsets.only(left: 25.0, top: 32.0, bottom: 11.0),
          child: Text(
            'Account Settings',
            style: kMainTextStyle.copyWith(
              color: const Color(0xFFB1B1B1),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.toNamed(ChangePassword.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 27.5, top: 18.0, bottom: 18.0),
            child: Row(
              children: [
                Image.asset(
                  'images/icon/lock.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 22.5),
                Text(
                  'Change Password',
                  style: kBodyTextStyle.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1.0,
          color: Color(0xFFE5E5E5),
        ),
        InkWell(
          onTap: () async {
            bool b = await onSignOut();
            if (b) {
              await DataManager.clear();
              //AppointmentManager.stop();
              //OneSignal.shared.removeExternalUserId();
              Get.offAllNamed(SignIn.routeName);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 27.5, top: 18.0, bottom: 18.0),
            child: Row(
              children: [
                Image.asset(
                  'images/icon/logout.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 22.5),
                Text(
                  'Logout',
                  style: kBodyTextStyle.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const AppActivityIndicator(),
      child: Scrollbar(
        child: buildContent(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}