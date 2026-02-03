import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';

class FamilyDetail extends StatefulWidget {

  final Family data;

  const FamilyDetail({
    super.key,
    required this.data,
  });

  @override
  State<FamilyDetail> createState() => _FamilyDetailState();
}

class _FamilyDetailState extends State<FamilyDetail> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }
  
  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          controller: scr,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 18.0),
            Text(
              'Full Name',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.fullname,
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Relationship',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.relationship ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'PRN',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.isPatient == true ? widget.data.prn ?? '-' : widget.data.docNum ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'NRIC / Passport',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.nricPassport ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Date of Birth',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.dob ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Gender',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.gender ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Marital Status',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.maritalStatus ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Nationality',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.nationality ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Email',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.email ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Contact Number',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.contact ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Address',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                widget.data.address ?? '-',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Family Member Details',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}