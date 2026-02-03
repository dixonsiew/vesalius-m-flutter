import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/my-family/add_family.dart';

class MyFamily extends StatelessWidget {

  static const String routeName = '/MyFamily';

  const MyFamily({super.key});

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Dismissible(
              key: const Key('0'),
              background: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              secondaryBackground: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              onDismissed: (direction) {
                
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withOpacity(0.3),
                      offset: const Offset(0, 4.0),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  child: InkWell(
                    onTap: () {
                      
                    },
                    borderRadius: BorderRadius.circular(5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kSecondaryColor2,
                            ),
                            child: Center(
                              child: Text(
                                'R',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: kTextColor1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Raja Abu bin Ahmad',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Father',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
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
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Dismissible(
              key: const Key('1'),
              background: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              secondaryBackground: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              onDismissed: (direction) {
                
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withOpacity(0.3),
                      offset: const Offset(0, 4.0),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  child: InkWell(
                    onTap: () {
                      
                    },
                    borderRadius: BorderRadius.circular(5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kSecondaryColor2,
                            ),
                            child: Center(
                              child: Text(
                                'N',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: kTextColor1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nadia binti Mohammad',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Spouse',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
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
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Dismissible(
              key: const Key('2'),
              background: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              secondaryBackground: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kSecondaryColor,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              onDismissed: (direction) {
                
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDBDBDB).withOpacity(0.3),
                      offset: const Offset(0, 4.0),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  child: InkWell(
                    onTap: () {
                      
                    },
                    borderRadius: BorderRadius.circular(5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kSecondaryColor2,
                            ),
                            child: Center(
                              child: Text(
                                'A',
                                style: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: kTextColor1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alia binti Abu',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Daughter',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
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
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'My Family Member',
      body: SafeArea(
        child: buildContent(),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const AddFamily());
          },
          icon: const Icon(
            Icons.add_circle_rounded,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}