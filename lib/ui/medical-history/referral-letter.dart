import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/data-label.dart';
import 'package:vesalius_m_flutter/components/medical-info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class ReferralLetter extends StatefulWidget {
  
  static final String routeName = 'ReferralLetter';

  final PatientVisit patientVisit;

  ReferralLetter({
    @required this.patientVisit,
  });

  @override
  _ReferralLetterState createState() => _ReferralLetterState();
}

class _ReferralLetterState extends State<ReferralLetter> {

  Widget buildRowHeader(String title) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ) +
        Border(
          bottom: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: kPrimaryBtnBgColor,
          fontSize: 16.0,
        ),
      ),
    );
  }

  void buildInternal(List<Widget> lx, NovaVisitReferralLetter o) {
    List<Widget> lk = [];
    lk.addAll([
      SizedBox(height: 10.0),
      DataLabel(
        label: 'Referrer Doctor: ',
        data: o.referrerDoctor ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Referral Doctor: ',
        data: o.referralDoctor ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Specialty: ',
        data: o.referralTitleDept ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Subject: ',
        data: o.referralAddressOrSubject ?? '-',
      ),
      SizedBox(height: 5.0),
      Text(
        'Referral Letter',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),

      Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xFFD3D3D3),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Colors.grey),
        ),
        child: Html(
          data: o.referralLetter,
          style: {
            'html': Style(
              fontSize: FontSize(15.0, units: 'pt'),
            ),
          }
        ),
      ),
      SizedBox(height: 10.0),
    ]);

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

  void buildExternal(List<Widget> lx, NovaVisitReferralLetter o) {
    List<Widget> lk = [];
    lk.addAll([
      SizedBox(height: 10.0),
      DataLabel(
        label: 'Referrer Doctor: ',
        data: o.referrerDoctor ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Referral Doctor: ',
        data: o.referralDoctor ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Title / Dept: ',
        data: o.referralTitleDept ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Address: ',
        data: o.referralAddressOrSubject ?? '-',
      ),
      SizedBox(height: 5.0),
      Text(
        'Referral Letter',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),

      Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xFFD3D3D3),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Colors.grey),
        ),
        child: Html(
          data: o.referralLetter,
          style: {
            'html': Style(
              fontSize: FontSize(15.0, units: 'pt'),
            ),
          }
        ),
      ),
      SizedBox(height: 10.0),
    ]);

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

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildContentList(),
    );
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < widget.patientVisit.novaVisitReferralLetterList.length; i++) {
      final o = widget.patientVisit.novaVisitReferralLetterList[i];
      final s = o.referralType;
      if (s == 'EXTERNAL') {
        lx.add(buildRowHeader(s));
        buildExternal(lx, o);
      }

      if (s == 'INTERNAL') {
        lx.add(buildRowHeader(s));
        buildInternal(lx, o);
      }
    }

    return lx;
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
        brightness: Brightness.dark,
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Referral Letter',
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