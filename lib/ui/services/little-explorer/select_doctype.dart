import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/doctype_data.dart';

class SelectDocType extends StatefulWidget {

  final DocType? selected;

  const SelectDocType({
    super.key,
    this.selected,
  });

  @override
  State<SelectDocType> createState() => _SelectDocTypeState();
}

class _SelectDocTypeState extends State<SelectDocType> {

  final List<DocType> list = [
    DocType(code: 'NRIC', name: 'NRIC'),
    DocType(code: 'Birth Cert', name: 'Birth Cert'),
    DocType(code: 'Passport', name: 'Passport'),
  ];

  final SelectDocTypeCtrl ctrl = Get.put(SelectDocTypeCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setData(widget.selected);
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, i) {
                final o = list[i];
                return ListTile(
                  onTap: () {
                    ctrl.setData(o);
                  },
                  title: Text(
                    o.name,
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                  trailing: Obx(() => o.name == ctrl.data?.name ? 
                  const Icon(
                    Icons.check,
                    color: kPrimaryColor,
                  ) : const SizedBox(
                    width: 24.0,
                    height: 24.0,
                  )),
                );
              },
              separatorBuilder: (context, i) {
                return Container(
                  height: 1.0,
                  color: const Color(0xFFDBDBDB),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'OK',
              onPressed: () {
                Get.back(result: ctrl.data);
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
      title: 'Select Identification Type',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class SelectDocTypeCtrl extends GetxController {

  final _data = Rx<DocType?>(null);

  void setData(DocType? o) {
    _data.value = o;
  }

  DocType? get data => _data.value;
}