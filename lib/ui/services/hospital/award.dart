import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class Award extends StatefulWidget {

  const Award({super.key});

  @override
  State<Award> createState() => _AwardState();
}

class _AwardState extends State<Award> {

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
              'Awards',
              style: kTextStyle1.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/08/website-award-logo-e1661407993270.jpg',
            title: 'Global Health Asia Pacific Awards 2022',
            year: '2022',
            name: 'Global Health Asia Pacific Awards',
            desc: '''
Medical Tourism Hospital
of the Year in Asia Pacific

Sports Rehab and Physiotherapy Service
of the Year in Asia Pacific

Most Resilient Hospital of the Year

Healthcare Technology Innovation Leadership Award

Diabetes Service Provider
of the Year in Asia Pacific
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/healthcare_2022.png',
            title: 'Healthcare Asia Awards 2022',
            year: '2022',
            name: 'Healthcare Asia Awards',
            desc: '''
Medical Tourism Initiative of the Year in Malaysia
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Global-Health-Asia-Pacific-Awards-2021.png',
            title: 'Global Health Asia Pacific Awards',
            year: '2021',
            name: 'Global Health Asia Pacific Awards',
            desc: '''
Hospital COVID-19 Healthcare Service Provider of the Year

Health Screening Provider of the Year

Sports Rehab and Physiotherapy Service of the Year in Asia Pacific
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Global-Health-Asia-Pacific-Awards-2020.png',
            title: 'Global Health Asia Pacific Awards',
            year: '2020',
            name: 'Global Health Asia Pacific Awards',
            desc: '''
Value Based Hospital of the Year in Asia Pacific
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Healthcare-Asia-Awards-2020.png',
            title: 'Healthcare Asia Awards 2020',
            year: '2020',
            name: 'Healthcare Asia Awards',
            desc: '''
Hospital of the Year in Malaysia and Diagnostics Provider of the Year in Malaysia
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Global-Brand-Award-Malaysia-Power-Brand-2018-2019.png',
            iimage: 'https://islandhospital.com/wp-content/uploads/2022/04/Global-Brand-Award.jpeg',
            title: 'Global Brand Award Malaysia Power Brand',
            year: '2018/2019',
            name: 'Global Brand Award Malaysia Power Brand',
            desc: '''
Quality Excellence Award in Healthcare
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/The-Star-Export-Excellence-Awards-Services-Category-for-large-companies.png',
            iimage: 'https://islandhospital.com/wp-content/uploads/2020/03/The-Stars-Export-Excellence-Award.jpeg',
            title: 'The Star Export Excellence Awards',
            year: '2019',
            name: 'The Star’s Export Excellence Award',
            desc: '''
Services Category for large companies
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Asia-Corporate-Excellence.png',
            title: 'Asia Corporate Excellence & Sustainability Awards',
            year: '2018',
            name: 'Asia Corporate Excellence & Sustainability Awards',
            desc: '''
Asia’s Best Performing Company
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Frost-Sullivan.png',
            iimage: 'https://islandhospital.com/wp-content/uploads/2022/04/Frost-Sullivan-Awards.jpeg',
            title: 'Frost & Sullivan Awards',
            year: '2017',
            name: 'Frost & Sullivan Awards',
            desc: '''
Malaysia Medical Tourism Hospital of the Year
''',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/The-Star-Outstanding-Business-Awards-2016.png',
            title: 'The Star Outstanding Business Awards',
            year: '2016',
            name: 'The Star Outstanding Business Awards',
          ),
          const SizedBox(height: 16.0),
          const AwardItem(
            image: 'https://islandhospital.com/wp-content/uploads/2022/05/Malaysia-Healthcare-Travel-Council-MHTC.png',
            title: 'Malaysia Healthcare Travel Council (MHTC)',
            year: '2012',
            name: 'Malaysia Healthcare Travel Council (MHTC)',
            desc: '''
Malaysia Top Medical Tourism Hospital
''',
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
            child: Text(
              'Accreditation',
              style: kTextStyle1.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'To retain its reputation as a trusted healthcare provider, Island Hospital is committed to continuously improve the standards and quality of care provided to its patients. In addition to its on-going accreditation by the Malaysian Standards and Quality in Healthcare (MSQH), the hospital is also recognised by the Australian Council on Healthcare Standards (ACHS) since October 2022 for its commitment to deliver the highest quality of care to its patients, based on international standards of healthcare assessment. The hospital is also accorded with Stage 5 certification in HIMSS Electronic Medical Record Adoption Model (EMRAM) which measures clinical outcomes, patient engagement and the use of electronic medical record technology within the organisation.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Image.network(
                    'https://islandhospital.com/wp-content/uploads/2023/03/msqh-300x180.jpg',
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Flexible(
                  child: Image.network(
                    'https://islandhospital.com/wp-content/uploads/2023/03/achs-300x180.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
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
      title: 'Awards & Accreditation',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class AwardItem extends StatelessWidget {

  final String image;
  final String title;
  final String year;
  final String name;
  final String? desc;
  final String? iimage;

  const AwardItem({
    super.key,
    required this.image,
    required this.title,
    required this.year,
    required this.name,
    this.desc,
    this.iimage,
  });

  void showDesc() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(bottom: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
                color: kPrimaryColor,
                splashRadius: 20.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.network(
                iimage ?? image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                year,
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kTextColor1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                name,
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kTextColor1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            if (desc != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  desc ?? '',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                image,
                width: 200.0,
                fit: BoxFit.cover,
              ),
              TextButton(
                onPressed: showDesc,
                style: TextButton.styleFrom(
                  foregroundColor: kTextColor1,
                ),
                child: Text(
                  title,
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}