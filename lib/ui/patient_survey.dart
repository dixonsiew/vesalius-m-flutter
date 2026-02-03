import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class PatientSurvey extends StatefulWidget {
  
  static const String routeName = '/PatientSurvey';

  const PatientSurvey({Key? key}) : super(key: key);

  @override
  State<PatientSurvey> createState() => _PatientSurveyState();
}

class _PatientSurveyState extends State<PatientSurvey> {

  bool isLoading = false;
  List<int> rates = [-1, -1, -1];
  String remark = '';
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

  Widget buildForm() {
    return Stack(
      children: [
        Scrollbar(
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
                  setState(() {
                    remark = s;
                  });
                }
              ),
              const SizedBox(height: 100.0),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(bottom: 42.0),
            color: const Color(0xFFF8F8F8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33.0),
              child: ElevatedButton(
                onPressed: !isValid ? null : (() {
                  print(rates);
                  print(remark);
                }),
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  backgroundColor: kMainColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                ),
                child: Text(
                  'Submit',
                  style: kMainTextStyle.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Patient Survey',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: buildForm(),
        ),
      ),
    );
  }
}

class RemarkQ extends StatefulWidget {
  
  final String question;
  final void Function(String) onChanged;

  const RemarkQ({
    Key? key, 
    required this.question,
    required this.onChanged,
  }) : super(key: key);

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
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: kBodyTextStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: txtremark,
            cursorColor: const Color(0xFF002E50),
            style: const TextStyle(
              fontFamily: kBodyFont,
              fontSize: 16.0,
              color: Color(0xFF002E50),
            ),
            maxLines: 3,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15.0),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Share your thoughts here',
              hintStyle: kBodyTextStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB1B1B1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFADADAD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Color(0xFFADADAD)),
              ),
            ),
            onChanged: (String s) {
              widget.onChanged(s);
            },
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
    Key? key, 
    required this.question,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RateQ> createState() => _RateQState();
}

class _RateQState extends State<RateQ> {

  int i = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: kBodyTextStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
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
                  widget.onTap(x);
                },
                child: Image.asset(
                  i >= 0 ? 'images/imgs/star1.png' : 'images/imgs/star0.png',
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 1;
                  });
                  widget.onTap(1);
                },
                child: Image.asset(
                  i >= 1 ? 'images/imgs/star1.png' : 'images/imgs/star0.png',
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 2;
                  });
                  widget.onTap(2);
                },
                child: Image.asset(
                  i >= 2 ? 'images/imgs/star1.png' : 'images/imgs/star0.png',
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 3;
                  });
                  widget.onTap(3);
                },
                child: Image.asset(
                  i >= 3 ? 'images/imgs/star1.png' : 'images/imgs/star0.png',
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10.0),
              InkWell(
                onTap: () {
                  setState(() {
                    i = 4;
                  });
                  widget.onTap(4);
                },
                child: Image.asset(
                  i >= 4 ? 'images/imgs/star1.png' : 'images/imgs/star0.png',
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}