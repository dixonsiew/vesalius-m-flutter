import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'checkout.dart';

class BillingDetail extends StatefulWidget {

  static const String routeName = '/BillingDetail';

  const BillingDetail({super.key});

  @override
  State<BillingDetail> createState() => _BillingDetailState();
}

class _BillingDetailState extends State<BillingDetail> {

  bool isValid = true;

  late final TextEditingController txtfullname;
  late final TextEditingController txtemail;
  late final TextEditingController txtaddr;
  late final TextEditingController txtpostcode;
  late final TextEditingController txtcontact1;
  late final TextEditingController txtcontact2;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    txtfullname = TextEditingController();
    txtemail = TextEditingController();
    txtaddr = TextEditingController();
    txtpostcode = TextEditingController();
    txtcontact1 = TextEditingController();
    txtcontact2 = TextEditingController();
  }

  @override
  void dispose() {
    txtfullname.dispose();
    txtemail.dispose();
    txtaddr.dispose();
    txtpostcode.dispose();
    txtcontact1.dispose();
    txtcontact2.dispose();
    super.dispose();
  }

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      setState(() {
        isValid = false;
      });
    }

    else {
      setState(() {
        isValid = b;
      });
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 18.0),
                    Text(
                      'Full Name',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kBgColor2.withOpacity(0.1),
                            offset: const Offset(0, 4.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Fullname is required').minLength(1, 'Fullname is required').build(),
                        controller: txtfullname,
                        cursorColor: kTextColor1,
                        style: const TextStyle(
                          fontFamily: kBodyFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'e.g.John Smith',
                          hintStyle: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor5,
                          ),
                          errorStyle: const TextStyle(
                            fontFamily: kBodyFont,
                            color: kTextColor3,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Text(
                      'Email',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kBgColor2.withOpacity(0.1),
                            offset: const Offset(0, 4.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                        controller: txtemail,
                        cursorColor: kTextColor1,
                        style: const TextStyle(
                          fontFamily: kBodyFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'e.g.JohnSmith@abc.com',
                          hintStyle: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor5,
                          ),
                          errorStyle: const TextStyle(
                            fontFamily: kBodyFont,
                            color: kTextColor3,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Text(
                      'Address',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kBgColor2.withOpacity(0.1),
                            offset: const Offset(0, 4.0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Address is required').minLength(1, 'Address is required').build(),
                        controller: txtaddr,
                        cursorColor: kTextColor1,
                        style: const TextStyle(
                          fontFamily: kBodyFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'e.g. 123, Main Street ',
                          hintStyle: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor5,
                          ),
                          errorStyle: const TextStyle(
                            fontFamily: kBodyFont,
                            color: kTextColor3,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 103.0,
                          child: Text(
                            'Postcode',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24.0),
                        Expanded(
                          child: Text(
                            'State',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 103.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: kBgColor2.withOpacity(0.1),
                                offset: const Offset(0, 4.0),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: validate,
                            validator: ValidationBuilder().required('Postcode is required').minLength(1, 'Postcode is required').build(),
                            controller: txtpostcode,
                            cursorColor: kTextColor1,
                            style: const TextStyle(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Postcode',
                              hintStyle: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                              errorStyle: const TextStyle(
                                fontFamily: kBodyFont,
                                color: kTextColor3,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: kTextColor3),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: kTextColor3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: const Color(0xFFC7CCD6)),
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withOpacity(0.1),
                                  offset: const Offset(0, 4.0),
                                  blurRadius: 4.0,
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
                                  padding: const EdgeInsets.only(left: 16.0, right: 14.0, top: 10.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Please Select',
                                          style: kTextStyle1.copyWith(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                            color: kTextColor1,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.expand_more,
                                        color: kTextColor1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22.0),
                    Text(
                      'Country',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: const Color(0xFFC7CCD6)),
                        boxShadow: [
                          BoxShadow(
                            color: kBgColor2.withOpacity(0.1),
                            offset: const Offset(0, 4.0),
                            blurRadius: 4.0,
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
                            padding: const EdgeInsets.only(left: 16.0, right: 14.0, top: 10.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Please Select',
                                    style: kTextStyle1.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: kTextColor1,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.expand_more,
                                  color: kTextColor1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    Text(
                      'Contact Number',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 78.85,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: kBgColor2.withOpacity(0.1),
                                offset: const Offset(0, 4.0),
                                blurRadius: 4.0,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: validate,
                            validator: ValidationBuilder().required('Contact Number is required').minLength(1, 'Contact Number is required').build(),
                            controller: txtcontact1,
                            cursorColor: kTextColor1,
                            style: const TextStyle(
                              fontFamily: kBodyFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor1,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '+60',
                              hintStyle: kTextStyle1.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                              errorStyle: const TextStyle(
                                fontFamily: kBodyFont,
                                color: kTextColor3,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: kTextColor3),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(color: kTextColor3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 13.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: kBgColor2.withOpacity(0.1),
                                  offset: const Offset(0, 4.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: validate,
                              validator: ValidationBuilder().required('Contact Number is required').minLength(1, 'Contact Number is required').build(),
                              controller: txtcontact2,
                              cursorColor: kTextColor1,
                              style: const TextStyle(
                                fontFamily: kBodyFont,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor1,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12.0),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'e.g 123338888',
                                hintStyle: kTextStyle1.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: kTextColor5,
                                ),
                                errorStyle: const TextStyle(
                                  fontFamily: kBodyFont,
                                  color: kTextColor3,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(color: Color(0xFFC7CCD6)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(color: kTextColor3),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(color: kTextColor3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'Next',
              onPressed: !isValid ? null : () {
                Get.to(() => const Checkout());
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
      title: 'Add Billing Details',
      body: SafeArea(
        child: buildForm(),
      ),
    );
  }
}