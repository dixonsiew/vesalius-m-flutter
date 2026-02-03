import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';

class SelectCountry extends StatefulWidget {

  final Country? selected;
  final List<Country> list;

  const SelectCountry({
    super.key,
    this.selected,
    required this.list,
  });

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {

  late final TextEditingController txtsearch;
  final SelectCountryCtrl ctrl = Get.put(SelectCountryCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    ctrl.setCountry(widget.selected);
    ctrl.setCountryList(widget.list);
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
                      ctrl.setCountry(o);
                    },
                    // leading: Text(
                    //   o.telCode ?? '',
                    //   style: kTextStyle1.copyWith(
                    //     fontSize: 16.0,
                    //     fontWeight: FontWeight.w400,
                    //     color: kTextColor1,
                    //   ),
                    // ),
                    title: Text(
                      o.countryName,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    trailing: Obx(() => o.countryName == ctrl.country?.countryName ? 
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
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEAEAEA).withValues(alpha: 0.21),
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
                  borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.35)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.35)),
                ),
              ),
              onChanged: (s) {
                if (s.isEmpty) {
                  ctrl.setCountryList(widget.list);
                }

                else {
                  final lx = widget.list.where((x) => x.countryCode.toLowerCase().contains(s.toLowerCase()) ||
                  x.countryName.toLowerCase().contains(s.toLowerCase())).toList();
                  ctrl.setCountryList(lx);
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
                Get.back(result: ctrl.country);
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

class SelectCountryCtrl extends GetxController {

  final _country = Rx<Country?>(null);
  final _list = <Country>[].obs;

  void setCountry(Country? o) {
    _country.value = o;
  }

  void setCountryList(List<Country> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  Country? get country => _country.value;
  List<Country> get list => [..._list];
}