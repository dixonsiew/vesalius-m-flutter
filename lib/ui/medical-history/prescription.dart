import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/medical-info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class Prescription extends StatefulWidget {
  
  static final String routeName = 'Prescription';

  final PatientVisit patientVisit;

  Prescription({
    @required this.patientVisit,
  });

  @override
  _PrescriptionState createState() => _PrescriptionState();
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
    var lx = widget.patientVisit.novaVisitPatientRxList ?? [];
    for (int i = 0; i < lx.length; i++) {
      final o = lx[i];
      String s = o.doctorName;
      if (map.containsKey(s)) {
        var ls = map[s];
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
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          'Doctor: $doctorName',
          style: TextStyle(
            color: Color(0xFF002E50),
            fontSize: 14.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Divider(
          color: Color(0xFFE0E0E0),
          height: 1.0,
          thickness: 1.0,
        ),
      ),
    ];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lx.addAll([
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Text(
            'Medications',
            style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: 12.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 10.0),
          child: Text(
            o.description,
            style: TextStyle(
              color: Color(0xFF002E50),
              fontSize: 14.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'Instruction',
            style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: 12.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
          child: Text(
            o.instruction,
            style: TextStyle(
              color: Color(0xFF002E50),
              fontSize: 14.0,
            ),
          ),
        ),
      ]);

      if (i < ls.length - 1) {
        lx.add(
          SizedBox(height: 5.0)
        );
      }
    }

    return lx;
  }

  void buildDoctorRx(List<Widget> lx, String doctorName) {
    final ls = map[doctorName];
    List<Widget> lk = [
      Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
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
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
      padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
      child: Text(
        'Prescription',
        style: TextStyle(
          color: kPrimaryBtnBgColor,
          fontSize: 16.0,
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
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Prescription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
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