import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/prescription-request/confirm_details.dart';

class PrescriptionRequest extends StatefulWidget {

  const PrescriptionRequest({super.key});

  @override
  State<PrescriptionRequest> createState() => _PrescriptionRequestState();
}

class _PrescriptionRequestState extends State<PrescriptionRequest> {

  int total = 0;
  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void onUpdateCount(bool b) {
    setState(() {
      if (b) {
        ++total;
      }

      else {
        --total;
      }
    });
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            controller: scr,
            child: ListView(
              controller: scr,
              shrinkWrap: true,
              children: [
                const SizedBox(height: 24.0),
                PrescriptionRequestItem(
                  name: 'Stada Stadeltine Levocetirizine 5mg Tablet',
                  desc: 'Unit of measurement : 10 tablets',
                  onUpdateCount: onUpdateCount,
                ),
                PrescriptionRequestItem(
                  name: 'Sunward Sunizine 10mg Tablet',
                  desc: 'Unit of measurement : 20 tablets',
                  onUpdateCount: onUpdateCount,
                ),
                PrescriptionRequestItem(
                  name: 'Telfast 30mg/5ml Paediatric Oral Suspension',
                  desc: 'Unit of measurement : 50ml/Bottle',
                  onUpdateCount: onUpdateCount,
                ),
                PrescriptionRequestItem(
                  name: 'Sandoz Cetyrol 10mg Tablet',
                  desc: 'Unit of measurement : 20 tablets',
                  onUpdateCount: onUpdateCount,
                ),
                PrescriptionRequestItem(
                  name: 'Ajalorin 5mg Orodispersible Tablet',
                  desc: 'Unit of measurement : 20 tablets',
                  onUpdateCount: onUpdateCount,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Submit',
              onPressed: total < 1 ? null : () {
                Get.to(() => const ConfirmDetails());
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Prescription Request',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class PrescriptionRequestItem extends StatefulWidget {

  final String name;
  final String desc;
  final void Function(bool) onUpdateCount;

  const PrescriptionRequestItem({
    super.key,
    required this.name,
    required this.desc,
    required this.onUpdateCount,
  });

  @override
  State<PrescriptionRequestItem> createState() => _PrescriptionRequestItemState();
}

class _PrescriptionRequestItemState extends State<PrescriptionRequestItem> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 18.0),
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
        child: Padding(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        widget.name,
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        widget.desc,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: count < 1 ? null : () {
                              if (count > 0) {
                                setState(() {
                                  --count;
                                });
                                widget.onUpdateCount.call(false);
                              }
                            },
                            splashRadius: 24.0,
                            icon: Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: count < 1 ? const Color(0xFFF4F4F4).withValues(alpha: 0.8) : kSecondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 16.0,
                                  color: count < 1 ? const Color(0xFFB1B1B1) : kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor4,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                ++count;
                              });
                              widget.onUpdateCount.call(true);
                            },
                            splashRadius: 24.0,
                            icon: Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 16.0,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}