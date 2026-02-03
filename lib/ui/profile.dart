import 'package:barcode_widget/barcode_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class Profile extends StatefulWidget {

  static const String routeName = 'Profile';

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool isLoading = false;
  PatientDetails? patientDetails;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
    var branchDetails = DataManager.branchDetails;
    try {
      setState(() {
        isLoading = true;
      });
      var patientData = await getVesaliusPatientData(branchDetails!.branch!.branchId!, branchDetails.prn!);
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
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(30.0),
            shape: BoxShape.rectangle,
            image: const DecorationImage(
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
                      child: QrImageView(
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
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: kBodyFont,
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
      var name = patientDetails!.name;
      s = '${name?.title} ${name?.firstName} ${name?.middleName} ${name?.lastName}';
    }

    return Stack(
      children: [
        Container(
          width: 300.0,
          height: 200.0,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(30.0),
            shape: BoxShape.rectangle,
            image: const DecorationImage(
              image: AssetImage('images/imgs/card.png'),
              fit: BoxFit.contain,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 85.0, left: 20.0, right: 20.0),
                    child: Text(
                      'PRN:',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: kBodyFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 85.0),
                    child: Text(
                      patientDetails == null ? '' : patientDetails!.prn ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: kBodyFont,
                        fontSize: 14.0,
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
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Text(
                      'Name:',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: kBodyFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: kBodyFont,
                        fontSize: 14.0,
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

  Widget buildLayer2() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                'images/icon/page-header-icon/profile.png',
                width: 65.0,
                height: 50.0,
                fit: BoxFit.contain,
              ),
              const Text(
                'View Your Personal Info',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: kTitleFont,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
          child: FlipCard(
            front: buildFrontCard(),
            back: buildBackCard(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Tap to flip the card',
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: kBodyFont,
                fontStyle: FontStyle.italic,
                color: Color(0xFFD3D3D3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayer1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 160.0,
          color: kProfileBgColor,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kProfileBgColor),
        backgroundColor: kProfileBgColor,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: Stack(
            children: [
              buildLayer1(),
              buildLayer2(),
            ],
          ),
        ),
      ),
    );
  }
}