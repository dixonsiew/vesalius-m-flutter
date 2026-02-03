import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class NotificationX extends StatelessWidget {

  static const String routeName = '/NotificationX';

  const NotificationX({super.key});

  Widget buildContent() {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 20.0),
            Text(
              'TODAY',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
            const SizedBox(height: 16.0),
            const NotificationItem(
              text: 'Patient Survey',
              content: 'We hope you enjoy our service! Let us know your feedback by taking this survey!',
              time: '03:00 PM',
            ),
            const NotificationItem(
              text: 'You are in queue.',
              content: '5 people ahead you. Please be prepared for your turn.',
              time: '02:00 PM',
            ),
            const NotificationItem(
              text: 'Prescription Order Request',
              content: 'You have submitted a prescription order request.',
              time: '09:00 AM',
            ),

            const SizedBox(height: 8.0),
            Text(
              'OLDER',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
            const SizedBox(height: 16.0),
            const NotificationItem(
              text: 'Upcoming Appointment',
              content: 'You have an upcoming appointment with Dr Wong on 11 Jan 2022 , 9AM.',
              time: '02:00 PM',
              isUnread: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Notification',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {

  final String text;
  final String content;
  final String time;
  final bool isUnread;

  const NotificationItem({
    super.key,
    required this.text,
    required this.content,
    required this.time,
    this.isUnread = false,
  });

  Widget buildUnread() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDADADA).withOpacity(0.4),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          onTap: () {
            
          },
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/icon/bell.png',
                  width: 48.0,
                  height: 48.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        content,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor2,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$time\n',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor2,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF4848),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isUnread) {
      return buildUnread();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDADADA).withOpacity(0.4),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          onTap: () {
            
          },
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/icon/bell.png',
                  width: 48.0,
                  height: 48.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        content,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}