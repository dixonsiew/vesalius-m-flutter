import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class SelectLanguage extends StatefulWidget {

  final String? selected;

  const SelectLanguage({
    super.key,
    this.selected,
  });

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {

  final List<String> list = ['English', 'Bahasa Melayu', 'Chinese', 'Tamil', 'Others'];

  final SelectLanguageCtrl ctrl = Get.put(SelectLanguageCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setData(widget.selected ?? '');
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
                return ListTile(
                  onTap: () {
                    ctrl.setData(list[i]);
                  },
                  title: Text(
                    list[i],
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                  trailing: Obx(() => list[i] == ctrl.data ? 
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
                  color: kColor1,
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
      title: 'Select Language',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class SelectLanguageCtrl extends GetxController {

  final _data = ''.obs;

  void setData(String s) {
    _data.value = s;
  }

  String get data => _data.value;
}