import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';

class SelectTel extends StatefulWidget {

  final CountryTel? selected;
  final List<CountryTel> list;

  const SelectTel({
    super.key,
    this.selected,
    required this.list,
  });

  @override
  State<SelectTel> createState() => _SelectTelState();
}

class _SelectTelState extends State<SelectTel> {

  late final TextEditingController txtsearch;
  final SelectTelCtrl ctrl = Get.put(SelectTelCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    ctrl.setTel(widget.selected);
    ctrl.setCountryTelList(widget.list);
  }

  @override
  void dispose() {
    txtsearch.dispose();
    super.dispose();
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70.0, bottom: 80.0),
          child: Scrollbar(
            child: Obx(() =>
              ListView.separated(
                shrinkWrap: true,
                itemCount: ctrl.list.length,
                itemBuilder: (context, i) {
                  final o = ctrl.list[i];
                  return ListTile(
                    onTap: () {
                      ctrl.setTel(o);
                    },
                    leading: Text(
                      o.telCode ?? '',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    title: Text(
                      o.countryName,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    trailing: Obx(() => o.countryName == ctrl.tel?.countryName ? 
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kColor6.withValues(alpha: 0.21),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: TextField(
              controller: txtsearch,
              autofocus: false,
              cursorColor: kPrimaryColor,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontFamily: kBodyFont,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: kTextColor1,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15.0),
                filled: true,
                fillColor: Colors.white,
                hintText: '',
                hintStyle: kTextStyle1.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: kTextColor5,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 15.0),
                  child: Icon(
                    Icons.search,
                    color: kPrimaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
                ),
              ),
              onChanged: (s) {
                if (s.isEmpty) {
                  ctrl.setCountryTelList(widget.list);
                }

                else {
                  final lx = widget.list.where((x) => x.countryName.toLowerCase().contains(s.toLowerCase())).toList();
                  ctrl.setCountryTelList(lx);
                }
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
                Get.back(result: ctrl.tel);
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
      title: 'Select Country',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class SelectTelCtrl extends GetxController {

  final _tel = Rx<CountryTel?>(null);
  final _list = <CountryTel>[].obs;

  void setTel(CountryTel? o) {
    _tel.value = o;
  }

  void setCountryTelList(List<CountryTel> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  CountryTel? get tel => _tel.value;
  List<CountryTel> get list => [..._list];
}