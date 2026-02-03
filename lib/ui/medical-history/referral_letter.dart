import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/data_label.dart';
import 'package:vesalius_m_flutter/components/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class ReferralLetter extends StatefulWidget {
  
  static const String routeName = 'ReferralLetter';

  final PatientVisit patientVisit;

  const ReferralLetter({
    Key? key,
    required this.patientVisit,
  }) : super(key: key);

  @override
  State<ReferralLetter> createState() => _ReferralLetterState();
}

class _ReferralLetterState extends State<ReferralLetter> {

  Widget buildRowHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: kPrimaryBtnBgColor,
          fontSize: 16.0,
          fontFamily: kBodyFont,
        ),
      ),
    );
  }

  void buildInternal(List<Widget> lx, NovaVisitReferralLetter o) {
    List<Widget> lk = [];
    lk.addAll([
      const SizedBox(height: 10.0),
      DataLabel(
        label: 'Referrer Doctor: ',
        data: o.referrerDoctor ?? '-',
      ),
      const SizedBox(height: 5.0),
      DataLabel(
        label: 'Referral Doctor: ',
        data: o.referralDoctor ?? '-',
      ),
      const SizedBox(height: 5.0),
      DataLabel(
        label: 'Specialty: ',
        data: o.referralTitleDept ?? '-',
      ),
      const SizedBox(height: 5.0),
      DataLabel(
        label: 'Subject: ',
        data: o.referralAddressOrSubject ?? '-',
      ),
      const SizedBox(height: 5.0),
      const Text(
        'Referral Letter',
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
        ),
      ),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFD3D3D3),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Colors.grey),
        ),
        child: Html(
          data: o.referralLetter,
          style: {
            'html': Style(
              fontSize: FontSize(15.0),
              fontFamily: kBodyFont,
            ),
          }
        ),
      ),
      const SizedBox(height: 10.0),
    ]);

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

  void buildExternal(List<Widget> lx, NovaVisitReferralLetter o) {
    List<Widget> lk = [];
    lk.addAll([
      const SizedBox(height: 10.0),
      DataLabel(
        label: 'Referrer Doctor: ',
        data: o.referrerDoctor ?? '-',
      ),
      const SizedBox(height: 5.0),
      DataLabel(
        label: 'Referral Doctor: ',
        data: o.referralDoctor ?? '-',
      ),
      const SizedBox(height: 5.0),
      DataLabel(
        label: 'Title / Dept: ',
        data: o.referralTitleDept ?? '-',
      ),
      const SizedBox(height: 5.0),
      DataLabel(
        label: 'Address: ',
        data: o.referralAddressOrSubject ?? '-',
      ),
      const SizedBox(height: 5.0),
      const Text(
        'Referral Letter',
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.bold,
        ),
      ),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: const Color(0xFFD3D3D3),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Colors.grey),
        ),
        child: Html(
          data: o.referralLetter,
          style: {
            'html': Style(
              fontSize: FontSize(15.0),
              fontFamily: kBodyFont,
            ),
          }
        ),
      ),
      const SizedBox(height: 10.0),
    ]);

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

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildContentList(),
    );
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < widget.patientVisit.novaVisitReferralLetterList!.length; i++) {
      final o = widget.patientVisit.novaVisitReferralLetterList![i];
      final s = o.referralType ?? '';
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
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Referral Letter',
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