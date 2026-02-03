import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class ConfirmDetails extends StatelessWidget {

  static const String routeName = '/ConfirmDetails';

  const ConfirmDetails({super.key});

  void showDone() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Submited Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your prescription order request has been submitted successfully. Our pharmacy officer will contact you within 3 working days.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DetailItem(
                      name: 'Stada Stadeltine Levocetirizine 5mg Tablet',
                      desc: '10 tablets',
                      count: 'x1',
                    ),
                    const DetailItem(
                      name: 'Sunward Sunizine 10mg Tablet',
                      desc: '20 tablets',
                      count: 'x1',
                    ),
                    const DetailItem(
                      name: 'Telfast 30mg/5ml Paediatric Oral Suspension',
                      desc: '50ml/Bottle',
                      count: 'x1',
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: kSecondaryColor2,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: kBgColor2.withOpacity(0.1),
                            offset: const Offset(0, 4.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon/info.png',
                            width: 17.06,
                            height: 16.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              'Our pharmacy officer will contact you within 3 working days to confirm the request.',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Confirm',
              onPressed: showDone,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Confirm Details',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {

  final String name;
  final String desc;
  final String count;

  const DetailItem({
    super.key,
    required this.name,
    required this.desc,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'images/icon/drug.png',
                width: 47.86,
                height: 48.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            desc,
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                        Text(
                          count,
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: kTextColor1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          color: kBgColor2,
        ),
      ],
    );
  }
}