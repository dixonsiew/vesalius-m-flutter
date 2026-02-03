import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class Prescription extends StatefulWidget {
  
  static const String routeName = '/Prescription';

  final PatientVisit patientVisit;

  const Prescription({
    Key? key, 
    required this.patientVisit,
  }) : super(key: key);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {

  Map<String, List<NovaVisitPatientRx>> map = {};
  List<String> doctorList = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    List<NovaVisitPatientRx> lx = widget.patientVisit.novaVisitPatientRxList ?? [];
    for (int i = 0; i < lx.length; i++) {
      final o = lx[i];
      String s = o.doctorName ?? '';
      if (map.containsKey(s)) {
        List<NovaVisitPatientRx> ls = map[s]!;
        ls.add(o);
      }

      else {
        List<NovaVisitPatientRx> ls = [o];
        map[s] = ls;
        doctorList.add(s);
      }
    }
  }

  List<Widget> buildDoctorContentList(List<NovaVisitPatientRx> ls, String doctorName) {
    List<Widget> lx = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          'Doctor: $doctorName',
          style: const TextStyle(
            color: Color(0xFF002E50),
            fontSize: 14.0,
            fontFamily: kBodyFont,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
    ];
    for (int i = 0; i < ls.length; i++) {
      NovaVisitPatientRx o = ls[i];
      lx.addAll([
        const Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Text(
            'Medications',
            style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: 12.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 10.0),
          child: Text(
            o.description ?? '',
            style: const TextStyle(
              color: Color(0xFF002E50),
              fontSize: 14.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'Instruction',
            style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: 12.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
          child: Text(
            o.instruction ?? '',
            style: const TextStyle(
              color: Color(0xFF002E50),
              fontSize: 14.0,
              fontFamily: kBodyFont,
            ),
          ),
        ),
      ]);

      if (i < ls.length - 1) {
        lx.add(
          const SizedBox(height: 5.0)
        );
      }
    }

    return lx;
  }

  void buildDoctorRx(List<Widget> lx, String doctorName) {
    final ls = map[doctorName]!;
    List<Widget> lk = [
      Material(
        elevation: 5.0,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: buildDoctorContentList(ls, doctorName),
          ),
        ),
      ),
    ];

    lx.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  Widget buildTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
      child: const Text(
        'Prescription',
        style: TextStyle(
          color: kPrimaryBtnBgColor,
          fontSize: 16.0,
          fontFamily: kBodyFont,
        ),
      ),
    );
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [
      buildTitle(),
    ];
    for (int i = 0; i < doctorList.length; i++) {
      buildDoctorRx(lx, doctorList[i]);
    }

    return lx;
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildContentList(),
    );
  }

  Widget buildHeader() {
    return MedicalInfo(
      patientVisit: widget.patientVisit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Prescription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(),
                buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}