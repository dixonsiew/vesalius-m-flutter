import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/bill_summary/bill_summary.dart';

class ReferralLetter extends StatelessWidget {

  static const String routeName = '/ReferralLetter';

  final PatientVisit patientVisit;

  const ReferralLetter({
    super.key,
    required this.patientVisit,
  });

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < patientVisit.novaVisitReferralLetterList.length; i++) {
      final NovaVisitReferralLetter o = patientVisit.novaVisitReferralLetterList[i];
      final String s = o.referralType ?? '';
      if (s == 'EXTERNAL') {
        lx.addAll([
          RowHeader(title: s.capitalize!),
          ExternalItem(o: o),
        ]);
      }

      if (s == 'INTERNAL') {
        lx.addAll([
          RowHeader(title: s.capitalize!),
          InternalItem(o: o),
        ]);
      }
    }

    return lx;
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          MedicalInfo(patientVisit: patientVisit),
          const SizedBox(height: 32.0),
          ...buildContentList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Referral Letter',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class RowHeader extends StatelessWidget {

  final String title;

  const RowHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        title,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class InternalItem extends StatelessWidget {

  final NovaVisitReferralLetter o;

  const InternalItem({
    super.key,
    required this.o,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4.0),
            blurRadius: 7.0,
            color: kBgColor2.withOpacity(0.7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BillData(
            label: 'Referrer Doctor',
            data: o.referrerDoctor ?? '-',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Referral Doctor',
            data: o.referralDoctor ?? '-',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Specialty',
            data: o.referralTitleDept ?? '-',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Subject',
            data: o.referralAddressOrSubject ?? '-',
          ),
          const SizedBox(height: 15.0),
          Text(
            'Referral Letter',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2FF),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Html(
              data: o.referralLetter,
              style: {
                'html': Style(
                  fontSize: FontSize(15.0),
                  fontFamily: kBodyFont,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExternalItem extends StatelessWidget {

  final NovaVisitReferralLetter o;

  const ExternalItem({
    super.key,
    required this.o,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4.0),
            blurRadius: 7.0,
            color: kBgColor2.withOpacity(0.7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BillData(
            label: 'Referrer Doctor',
            data: o.referrerDoctor ?? '-',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Referral Doctor',
            data: o.referralDoctor ?? '-',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Title / Dept',
            data: o.referralTitleDept ?? '-',
          ),
          const SizedBox(height: 15.0),
          BillData(
            label: 'Address',
            data: o.referralAddressOrSubject ?? '-',
          ),
          const SizedBox(height: 15.0),
          Text(
            'Referral Letter',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor2,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2FF),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Html(
              data: o.referralLetter,
              style: {
                'html': Style(
                  fontSize: FontSize(15.0),
                  fontFamily: kBodyFont,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}