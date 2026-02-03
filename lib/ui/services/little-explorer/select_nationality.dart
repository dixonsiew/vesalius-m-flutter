import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class SelectNationality extends StatefulWidget {

  final String? selected;
  final List<String> list;

  const SelectNationality({
    super.key,
    this.selected,
    required this.list,
  });

  @override
  State<SelectNationality> createState() => _SelectNationalityState();
}

class _SelectNationalityState extends State<SelectNationality> {

  /* final List<String> list = ['Malaysia', 'Indonesia', 'Andorra', 'Angola', 'Antigua & Deps',
  'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan',
  'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus',
  'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia',
  'Bosnia Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria',
  'Burkina', 'Burundi', 'Cambodia', 'Cameroon', 'Canada',
  'Cape Verde', 'Central African Rep', 'Chad', 'Chile', 'China',
  'Colombia', 'Comoros', 'Congo', 'Congo {Democratic Rep}', 'Costa Rica',
  'Croatia', 'Cuba', 'Cyprus', 'Czech Republic', 'Denmark',
  'Djibouti', 'Dominica', 'Dominican Republic', 'East Timor', 'Ecuador',
  'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia',
  'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon',
  'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece',
  'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana',
  'Haiti', 'Honduras', 'Hungary', 'Iceland', 'India',
  'Iran', 'Iraq', 'Ireland {Republic}', 'Israel', 'Italy',
  'Ivory Coast', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan',
  'Kenya', 'Kiribati', 'Korea North', 'Korea South', 'Kosovo',
  'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon',
  'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania',
  'Luxembourg', 'Macedonia', 'Madagascar', 'Malawi', 'Maldives',
  'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius',
  'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia',
  'Montenegro', 'Morocco', 'Mozambique', 'Myanmar, (Burma)', 'Namibia',
  'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua',
  'Niger', 'Nigeria', 'Norway', 'Oman', 'Pakistan',
  'Palau', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru',
  'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania',
  'Russian Federation', 'Rwanda', 'St Kitts & Nevis', 'St Lucia', 'Saint Vincent & the Grenadines',
  'Samoa', 'San Marino', 'Sao Tome & Principe', 'Saudi Arabia', 'Senegal',
  'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia',
  'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Sudan',
  'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Swaziland',
  'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan',
  'Tanzania', 'Thailand', 'Togo', 'Tonga', 'Trinidad & Tobago',
  'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda',
  'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States', 'Uruguay',
  'Uzbekistan', 'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam',
  'Yemen', 'Zambia', 'Zimbabwe',
  'Others']; */

  late final TextEditingController txtsearch;
  final SelectNationalityCtrl ctrl = Get.put(SelectNationalityCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    ctrl.setData(widget.selected ?? '');
    ctrl.setNationalityList(widget.list);
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
                      ctrl.setData(o);
                    },
                    title: Text(
                      o,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    trailing: Obx(() => o == ctrl.data ? 
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
                  ctrl.setNationalityList(widget.list);
                }

                else {
                  final lx = widget.list.where((x) => x.toLowerCase().contains(s.toLowerCase())).toList();
                  ctrl.setNationalityList(lx);
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
      title: 'Select Nationality',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class SelectNationalityCtrl extends GetxController {

  final _data = ''.obs;
  final _list = <String>[].obs;

  void setData(String s) {
    _data.value = s;
  }

  void setNationalityList(List<String> lx) {
    _list.clear();
    _list.addAllIf(lx.isNotEmpty, lx);
  }

  String get data => _data.value;
  List<String> get list => [..._list];
}