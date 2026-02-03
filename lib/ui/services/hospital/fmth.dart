import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class FMTH extends StatefulWidget {

  const FMTH({super.key});

  @override
  State<FMTH> createState() => _FMTHState();
}

class _FMTHState extends State<FMTH> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }
  
  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
            child: Text(
              'Flagship Medical Tourism Hospital Programme',
              style: kTextStyle1.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kTextColor1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Image.asset(
              'images/imgs/hospital/fmth.png',
              width: 320.0,
              height: 135.0,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              '''Island Hospital is proud to announce that it has been shortlisted as a finalist for Malaysia’s Flagship Medical Tourism Hospital Programme. This innovative initiative, spearheaded by the Malaysia Healthcare Travel Council (MHTC), seeks to establish new standards in global healthcare travel by positioning Malaysia as a world-renowned icon for healthcare travel.

Fully endorsed by the Government of Malaysia and the Ministry of Health, the programme is a collaborative effort with international bodies IQVIA and Joint Commission International (JCI). It aims to deliver exceptional end-to-end patient experiences anchored on medical and service excellence best practices and international branding. The programme is a critical component of the five-year Malaysia Healthcare Travel Industry blueprint, which aims to provide the Best Malaysia Healthcare Travel Experience by 2025.

Island Hospital’s recognition as a finalist in this programme is a testament to its commitment to providing high-quality healthcare services that meet international standards. This achievement is a result of the hospital’s relentless efforts in ensuring patient safety, providing outstanding medical care, and delivering exceptional patient experiences.

Having been active in medical tourism for over 20 years, Island Hospital has been actively investing into growing and developing its infrastructure and expertise to meet the needs of its local and international patients. Through a public-private partnership with the Penang State, the Island Medical City was conceived in 2016 as a commitment towards taking medical tourism in Penang and in Malaysia to the next level. This ambitious project marks the evolution of Island Hospital into a leading regional quaternary healthcare provider offering the Best in Class care for patients and a key part of the aspiration to become one of the largest and most prominent medical establishments in South-East Asia.

This vision dovetails perfectly with the goals of the Flagship Medical Tourism Hospital Programme. With the commissioning of new and expanded facilities, the Peel Wing in October 2022, Island Hospital is poised to achieve the goal of healthcare travellers making up to 80% of its revenue in the next few years. As part of this commitment to providing quality healthcare, since 2018, the hospital has invested over RM0.5 billion into building up its physical infrastructure, health digitalization and human capital. Through strategic partnerships with public and private stakeholders, it is estimated that in 2023, the economic spill over from healthcare travellers to Penang will be over RM1 billion a year from upstream and downstream activities in hospitality, services, retail and transport sectors.

Being shortlisted as a finalist for this prestigious programme is a significant achievement for Island Hospital, and we are proud to be a part of it, as the hospital remains committed to providing high-quality healthcare services that meet international standards and delivering exceptional patient experiences.''',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}