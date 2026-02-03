import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';

class AllergiesGroup extends StatelessWidget {

  static const String routeName = 'AllergiesGroup';

  final String title;
  final List<Allergy> list;

  const AllergiesGroup({
    Key? key,
    required this.title,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    list.sort((a, b) {
      DateTime? dt1 = DateTime.tryParse(a.creationDate!);
      DateTime? dt2 = DateTime.tryParse(b.creationDate!);
      return dt2!.compareTo(dt1!);
    });

    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kAllergiesBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kAllergiesBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontFamily: kTitleFont,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF6F6F6),
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                Allergy o = list[i];
                return AllergiesGroupItem(
                  allergy: o,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AllergiesGroupItem extends StatelessWidget {

  final Allergy allergy;

  const AllergiesGroupItem({
    Key? key,
    required this.allergy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20.0),
            child: Text(
              allergy.description?.toUpperCase() ?? '',
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: kBodyFont,
                color: kPrimaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 11.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Flexible(
                  flex: 2,
                  child: Text(
                    'Records By ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: kBodyFont,
                      color: Color.fromRGBO(5, 5, 5, 0.411),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    allergy.createdBy == null || allergy.createdBy == '' ? '-' : allergy.createdBy!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: kBodyFont,
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                ),
                const Flexible(
                  child: Text(
                    ' on ',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: kBodyFont,
                      color: Color.fromRGBO(5, 5, 5, 0.411),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    formatDateTime(allergy.creationDate!),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: kBodyFont,
                      color: Color.fromARGB(255, 100, 100, 100),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 11.0),
            child: Text(
              'Reaction',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: kBodyFont,
                color: Color.fromRGBO(5, 5, 5, 0.411),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              allergy.reaction == null || allergy.reaction == '' ? '-' : allergy.reaction!,
              style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, top: 11.0),
            child: Text(
              'Inactive Reason',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: kBodyFont,
                color: Color.fromRGBO(5, 5, 5, 0.411),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: Text(
              allergy.inactiveReason == null || allergy.inactiveReason == '' ? '-' : allergy.inactiveReason!,
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: kBodyFont,
                color: Color.fromARGB(255, 100, 100, 100),
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
            color: Color.fromARGB(255, 226, 226, 226),
          ),
        ],
      ),
    );
  }
}