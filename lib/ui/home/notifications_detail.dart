import 'package:flutter/gestures.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/notification_data.dart';
import 'package:vesalius_m_flutter/ui/services/feedback_ih.dart';

class NotificationsDetail extends StatelessWidget {

  final NotificationX data;

  const NotificationsDetail({
    super.key,
    required this.data,
  });

  String get image {
    String s = 'general-info1.png';
    if (data.msgType == 'PROMOTION') {
      s = 'promotion1.png';
    }

    else if (data.msgType == 'QUEUE_NOTIFICATION') {
      s = 'queue-notification1.png';
    }

    else if (data.msgType == 'UPCOMING_APPT') {
      s = 'upcoming-appt1.png';
    }

    else if (data.msgType == 'PATIENT_FEEDBACK') {
      s = 'patient-feedback1.png';
    }

    return s;
  }

  Widget buildFeedbackMsg() {
    //String s = data.fullMessage.replaceAll('[TAPPING HERE] to fill out your feedbacks.', '');
    return Wrap(
      children: [
        EasyRichText(
          data.fullMessage,
          defaultStyle: kTextStyle1.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4D4D4D),
          ),
          patternList: [
            EasyRichTextPattern(
              targetString: '(\\*)(.*?)(\\*)',
              matchBuilder: (BuildContext context, RegExpMatch? match) {
                // print(match[0]);
                return TextSpan(
                  text: match?[0]?.replaceAll('*', ''),
                  style: kTextStyle1.copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '\nKindly take a moment to share your thoughts by ',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4D4D4D),
                ),
              ),
              TextSpan(
                text: 'CLICKING HERE',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor: kPrimaryColor,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  Get.to(() => FeedbackIH(
                    visitType: data.visitType,
                    accountNo: data.accountNo,
                  ));
                },
              ),
              TextSpan(
                text: ' to fill out your feedbacks.',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4D4D4D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40.0,
              color: const Color(0xFFD4E8E8),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 55.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    data.notificationTitle,
                    style: kTextStyle1.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    data.dateTime,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor5,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (data.msgType == 'PATIENT_FEEDBACK' && data.accountNo != null) ...[
                    buildFeedbackMsg(),
                  ] else ...[
                    EasyRichText(
                      data.fullMessage,
                      defaultStyle: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4D4D4D),
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          targetString: '(\\*)(.*?)(\\*)',
                          matchBuilder: (BuildContext context, RegExpMatch? match) {
                            // print(match[0]);
                            return TextSpan(
                              text: match?[0]?.replaceAll('*', ''),
                              style: kTextStyle1.copyWith(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                    /* Text(
                      data.fullMessage,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF4D4D4D),
                      ),
                    ), */
                  ],
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(
              'images/icon/$image',
              width: 64.0,
              height: 64.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Details',
      elevation: 0.0,
      appBarBackgroundColor: const Color(0xFFD4E8E8),
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}