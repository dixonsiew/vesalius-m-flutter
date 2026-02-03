import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class InpatientJourney extends StatefulWidget {

  const InpatientJourney({super.key});

  @override
  State<InpatientJourney> createState() => _InpatientJourneyState();
}

class _InpatientJourneyState extends State<InpatientJourney> {

  bool isExpand = false;
  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  Widget buildContent1() {
    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          controller: scr,
          shrinkWrap: true,
          children: [
            const SizedBox(height: 24.0),
            TimelineTile(
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                indicator: Image.asset(
                  'images/icon/tick2.png',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.cover,
                ),
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFF08AB92),
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1FFF9),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFF08AB92)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Admission Appointment',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Image.asset(
                          'images/icon/clock4.png',
                          width: 15.36,
                          height: 15.36,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '03 Dec 2022, 8:30 AM',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const EmptyTimeline(color: Color(0xFF08AB92)),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Image.asset(
                  'images/icon/tick2.png',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.cover,
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF08AB92),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFF08AB92),
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1FFF9),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFF08AB92)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Registration',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Image.asset(
                          'images/icon/clock4.png',
                          width: 15.36,
                          height: 15.36,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '03 Dec 2022, 8:30 AM',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const EmptyTimeline(color: Color(0xFF08AB92)),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Image.asset(
                  'images/icon/tick2.png',
                  width: 24.0,
                  height: 24.0,
                  fit: BoxFit.cover,
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF08AB92),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFF08AB92),
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1FFF9),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFF08AB92)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pre Admission',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Ward 12- Bed 13',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const EmptyTimeline(color: Color(0xFF08AB92)),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Center(
                    child: Text(
                      '4',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFF08AB92),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: kPrimaryColor),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Admission',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Ward 12- Bed 13',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const EmptyTimeline(),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '5',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  'Preliminary Discharge',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
            ),

            const EmptyTimeline(),

            TimelineTile(
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '6',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  'Discharge',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
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
            const SizedBox(height: 24.0),
            TimelineTile(
              isFirst: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: kPrimaryColor),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Admission Appointment',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Image.asset(
                          'images/icon/clock4.png',
                          width: 15.36,
                          height: 15.36,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '03 Dec 2022, 8:30 AM',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const EmptyTimeline(),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                margin: const EdgeInsets.only(left: 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isExpand = !isExpand;
                      });
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Registration',
                                style: kTextStyle1.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: kTextColor1,
                                ),
                              ),
                              Icon(
                                isExpand ? Icons.expand_less : Icons.expand_more,
                                color: kTextColor1,
                              ),
                            ],
                          ),
                          if (isExpand) ...[
                            ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. ',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: kTextColor2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'You are required to bring all relevant documents on the day of admission. (e.g. Patients submitting documents for pre-admission: bring admission form).',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '2. ',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: kTextColor2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'You will be briefed on the terms and conditions of their stay.',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '3. ',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: kTextColor2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Bed is booked depending on availability.',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '4. ',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: kTextColor2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'You are required to pay a deposit at the Business Office counter.',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const EmptyTimeline(),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '3',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  'Pre Admission',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
            ),

            const EmptyTimeline(),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '4',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  'Admission',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
            ),

            const EmptyTimeline(),

            TimelineTile(
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '5',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              afterLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  'Preliminary Discharge',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
            ),

            const EmptyTimeline(),

            TimelineTile(
              isLast: true,
              indicatorStyle: IndicatorStyle(
                indicator: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xFFDADADA)),
                  ),
                  child: Center(
                    child: Text(
                      '6',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor2,
                      ),
                    ),
                  ),
                ),
              ),
              beforeLineStyle: const LineStyle(
                color: Color(0xFFDADADA),
                thickness: 2,
              ),
              endChild: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  'Discharge',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
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
      title: 'Inpatient Journey',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class EmptyTimeline extends StatelessWidget {

  final double height;
  final Color color;

  const EmptyTimeline({
    super.key,
    this.height = 30.0,
    this.color = const Color(0xFFDADADA),
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      indicatorStyle: IndicatorStyle(
        indicator: Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              '',
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w700,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
      endChild: SizedBox(height: height),
      beforeLineStyle: LineStyle(
        color: color,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: color,
        thickness: 2,
      ),
    );
  }
}