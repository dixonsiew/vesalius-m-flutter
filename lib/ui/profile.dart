import 'package:barcode_widget/barcode_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth-manager.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

class Profile extends StatefulWidget {

  static final String routeName = 'Profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool isLoading = false;
  PatientDetails patientDetails;

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
      var patientData = await getVesaliusPatientData(branchDetails.branch.branchId, branchDetails.prn);
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
      s = patientDetails.prn;
    }

    return Stack(
      children: [
        Container(
          width: 300.0,
          height: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage('images/imgs/cardb.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
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
                    padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      child: QrImage(
                        data: s,
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 70.0),
                    child: BarcodeWidget(
                      barcode: Barcode.code128(), // Barcode type and settings
                      data: s, // Content
                      width: 105.0,
                      height: 60.0,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
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
      var name = patientDetails.name;
      s = '${name.title} ${name.firstName} ${name.middleName} ${name.lastName}';
    }

    return Stack(
      children: [
        Container(
          width: 300.0,
          height: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: AssetImage('images/imgs/card.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
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
                    padding: EdgeInsets.only(top: 85.0, left: 20.0, right: 20.0),
                    child: Text(
                      'PRN:',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 85.0),
                    child: Text(
                      patientDetails == null ? '' : patientDetails.prn,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Text(
                      'Name:',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
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
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 120.0, bottom: 120.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(133, 133, 133, 0.29),
              offset: Offset(5, 4),
              blurRadius: 10.0,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: FlipCard(
                front: buildFrontCard(),
                back: buildBackCard(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0, left: 55.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tap to flip the card',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFFD3D3D3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLayer1() {
    return Container(
      width: double.infinity,
      height: 160.0,
      color: kProfileBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              width: 80.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage('images/icon/page-header-icon/profile.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text(
              'View Your Personal Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: kProfileBgColor,
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
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