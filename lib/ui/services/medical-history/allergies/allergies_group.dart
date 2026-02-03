import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';

class AllergiesGroup extends StatelessWidget {

  static const String routeName = '/AllergiesGroup';

  final String title;
  final List<Allergy> list;

  AllergiesGroup({
    super.key,
    required this.title,
    required this.list,
  }) {
    list.sort((a, b) {
      DateTime? dt1 = DateTime.tryParse(a.creationDate!);
      DateTime? dt2 = DateTime.tryParse(b.creationDate!);
      return dt2!.compareTo(dt1!);
    });
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: list.length + 1,
        itemBuilder:(context, index) {
          if (index == 0) {
            return const SizedBox(height: 23.0);
          }

          Allergy o = list[index - 1];
          return AllergiesGroupItem(
            allergy: o,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: title,
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class AllergiesGroupItem extends StatelessWidget {

  final Allergy allergy;

  const AllergiesGroupItem({
    super.key,
    required this.allergy,
  });

  String formatDateTime(String ds) {
  String s = ds;
  DateTime? dt = DateTime.tryParse(ds);

  if (dt != null) {
    s = formatDate(dt, [dd, '-', M, '-', yyyy]);
  }

  return s;
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            color: kBgColor2.withOpacity(0.7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: kSecondaryColor2,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              allergy.description?.toUpperCase() ?? '',
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Record By',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  allergy.createdBy == null || allergy.createdBy == '' ? '-' : allergy.createdBy!,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Record Date',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  formatDateTime(allergy.creationDate!),
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reaction',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  allergy.reaction == null || allergy.reaction == '' ? '-' : allergy.reaction!,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Inactive Reason',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  allergy.inactiveReason == null || allergy.inactiveReason == '' ? '-' : allergy.inactiveReason!,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}