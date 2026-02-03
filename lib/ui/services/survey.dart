import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class Survey extends StatefulWidget {

  static const String routeName = '/Survey';

  const Survey({super.key});

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {

  List<int> rates = [-1, -1, -1];
  late final TextEditingController txtremark;

  @override
  void initState() {
    super.initState();
    txtremark = TextEditingController();
  }

  @override
  void dispose() {
    txtremark.dispose();
    super.dispose();
  }

  bool get isValid {
    bool b = true;
    if (rates.any((o) => o == -1)) return false;
    return b;
  }

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
              'images/icon/success.png',
              width: 55.0,
              height: 55.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Thank you for sharing!',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'We appreciate your feedback and rating.',
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

  void onSubmit() {
    showDone();
  }

  Widget buildForm() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 24.0),
          RateQ(
            question: 'How easy was it to schedule appointment with our facility?',
            onTap: (int i) {
              setState(() {
                rates[0] = i;
              });
            },
          ),
          const SizedBox(height: 24.0),
          RateQ(
            question: 'How satisfied are you with the skill and competency of the staff?',
            onTap: (int i) {
              setState(() {
                rates[1] = i;
              });
            },
          ),
          const SizedBox(height: 24.0),
          RateQ(
            question: 'How would you rate the overall care you received from your provider?',
            onTap: (int i) {
              setState(() {
                rates[2] = i;
              });
            },
          ),
          const SizedBox(height: 24.0),
          RemarkQ(
            question: 'How we can improve to serve you better?',
            onChanged: (String s) {
              
            },
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppElevatedButton(
              text: 'Submit',
              onPressed: !isValid ? null : onSubmit,
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
      title: 'Survey',
      body: SafeArea(
        child: buildForm(),
      ),
    );
  }
}

class RateIcon extends StatelessWidget {

  final int rate;
  final int index;

  const RateIcon({
    super.key,
    required this.rate,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      rate >= index ? 'images/imgs/star1.png' : 'images/imgs/star0.png',
      width: 40.0,
      height: 40.0,
      fit: BoxFit.contain,
    );
  }
}

class RemarkQ extends StatefulWidget {
  
  final String question;
  final void Function(String) onChanged;

  const RemarkQ({
    super.key, 
    required this.question,
    required this.onChanged,
  });

  @override
  State<RemarkQ> createState() => _RemarkQState();
}

class _RemarkQState extends State<RemarkQ> {

  late final TextEditingController txtremark;

  @override
  void initState() {
    super.initState();
    txtremark = TextEditingController();
  }

  @override
  void dispose() {
    txtremark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withOpacity(0.5),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4.0),
                  blurRadius: 4.0,
                  color: kBgColor2.withOpacity(0.1),
                ),
              ],
            ),
            child: TextField(
              controller: txtremark,
              cursorColor: kTextColor1,
              style: const TextStyle(
                fontFamily: kBodyFont,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
              maxLines: 3,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15.0),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Share your thoughts here',
                hintStyle: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFB1B1B1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFDADADA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFDADADA)),
                ),
              ),
              onChanged: (String s) {
                widget.onChanged.call(s);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RateQ extends StatefulWidget {
  
  final String question;
  final void Function(int) onTap;

  const RateQ({
    super.key,
    required this.question,
    required this.onTap,
  });

  @override
  State<RateQ> createState() => _RateQState();
}

class _RateQState extends State<RateQ> {

  int i = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withOpacity(0.5),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  int x = i == 0 ? -1 : 0;
                  setState(() {
                    i = x;
                  });
                  widget.onTap.call(x);
                },
                child: RateIcon(rate: i, index: 0),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 1;
                  });
                  widget.onTap.call(1);
                },
                child: RateIcon(rate: i, index: 1),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 2;
                  });
                  widget.onTap.call(2);
                },
                child: RateIcon(rate: i, index: 2),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 3;
                  });
                  widget.onTap.call(3);
                },
                child: RateIcon(rate: i, index: 3),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 4;
                  });
                  widget.onTap.call(4);
                },
                child: RateIcon(rate: i, index: 4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}