import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class HealthScreenRpt extends StatelessWidget {
  
  final PatientVisit patientVisit;

  const HealthScreenRpt({
    Key? key, 
    required this.patientVisit,
  }) : super(key: key);

  Widget buildContent() {
    return Container();
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
        title: const Text(
          'Health Screening Report',
          style: kTitleTextStyle,
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}