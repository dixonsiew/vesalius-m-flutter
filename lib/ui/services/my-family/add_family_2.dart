import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class AddFamily2 extends StatefulWidget {

  static const String routeName = '/AddFamily2';

  const AddFamily2({super.key});

  @override
  State<AddFamily2> createState() => _AddFamily2State();
}

class _AddFamily2State extends State<AddFamily2> {

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
              'Family Member Added Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Aliff Bin Abu ',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor4,
                    ),
                  ),
                  TextSpan(
                    text: 'has been added to as your family.',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor2,
                    ),
                  ),
                ],
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

  void onSubmit() async {
    showDone();
  }

  void onSubmitDelete() async {

  }

  Future<void> onDelete() async {
    bool b = await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure want to delete family member Raja Abu bin Ahmad?',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kTextColor2,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      side: const BorderSide(
                        color: Color(0xFFDBDBDB),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Delete',
                    onPressed: () => Get.back(result: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? false;
    if (b) {
      onSubmitDelete();
    }
  }

  Widget buildForm() {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                'Aliff Bin Abu',
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                'Son',
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                '10034123',
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                '980910-01-8990',
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
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
                  Expanded(
                    child: Text(
                      '10/09/1978',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month,
                    color: kTextColor1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22.0),

            Text(
              'Gender',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                'Male',
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                'Malaysian',
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf4f4f4).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: const Color(0xFFC7CCD6)),
                    boxShadow: [
                      BoxShadow(
                        color: kBgColor2.withOpacity(0.1),
                        offset: const Offset(0, 4.0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Text(
                    '+60',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(width: 13.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf4f4f4).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: const Color(0xFFC7CCD6)),
                      boxShadow: [
                        BoxShadow(
                          color: kBgColor2.withOpacity(0.1),
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Text(
                      '162700438',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                ),
              ],
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
                color: const Color(0xFFf4f4f4).withOpacity(0.8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFFC7CCD6)),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                'NO 123, Taman Gembira, 58000 Kuala Lumpur',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            AppElevatedButton(
              text: 'Add Family Member',
              onPressed: onSubmit,
            ),
            const SizedBox(height: 24.0),
            AppOutlinedButton(
              text: 'Cancel',
              onPressed: () => Get.back(),
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
        child: buildForm(),
      ),
      actions: [
        IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}