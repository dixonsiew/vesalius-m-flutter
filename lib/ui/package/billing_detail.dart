import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

class BillingDetail extends StatefulWidget {

  static const String routeName = '/BillingDetail';

  const BillingDetail({Key? key}) : super(key: key);

  @override
  State<BillingDetail> createState() => _BillingDetailState();
}

class _BillingDetailState extends State<BillingDetail> {

  bool isValid = false;
  bool isLoading = false;
  final txtfullname = TextEditingController();
  final txtemail = TextEditingController();
  final txtaddr = TextEditingController();
  final txtpostcode = TextEditingController();
  final txtcontact = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    
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

  void onSubmit() {

  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 27.0),
                  Text(
                    'Full Name',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('Fullname is required').minLength(1, 'Fullname is required').build(),
                    controller: txtfullname,
                    cursorColor: const Color(0xFF002E50),
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 16.0,
                      color: Color(0xFF002E50),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'e.g.John Smith',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
                        color: Color(0xFFFA4954),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Email',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').email('Email is invalid').build(),
                    controller: txtemail,
                    cursorColor: const Color(0xFF002E50),
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 16.0,
                      color: Color(0xFF002E50),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'e.g.JohnSmith@abc.com',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
                        color: Color(0xFFFA4954),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Address',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: validate,
                    validator: ValidationBuilder().required('Address is required').minLength(1, 'Address is required').build(),
                    controller: txtaddr,
                    cursorColor: const Color(0xFF002E50),
                    style: const TextStyle(
                      fontFamily: kBodyFont,
                      fontSize: 16.0,
                      color: Color(0xFF002E50),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'e.g. 123, Main Street',
                      hintStyle: kBodyTextStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB1B1B1),
                      ),
                      errorStyle: const TextStyle(
                        fontFamily: kBodyFont,
                        color: Color(0xFFFA4954),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Color(0xFFFA4954)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Postcode',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(
                        child: Text(
                          'State',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: validate,
                          validator: ValidationBuilder().required('Postcode is required').minLength(1, 'Postcode is required').build(),
                          controller: txtpostcode,
                          cursorColor: const Color(0xFF002E50),
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            color: Color(0xFF002E50),
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Postcode',
                            hintStyle: kBodyTextStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB1B1B1),
                            ),
                            errorStyle: const TextStyle(
                              fontFamily: kBodyFont,
                              color: Color(0xFFFA4954),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color(0xFFFA4954)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color(0xFFFA4954)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15.0, right: 14.0, top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: const Color.fromRGBO(219, 219, 219, 0.2)),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 4.0),
                                blurRadius: 4.0,
                                color: Color.fromRGBO(229, 220, 229, 0.1),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Please Select',
                                  style: kBodyTextStyle.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Image.asset(
                                'images/icon/down.png',
                                width: 20.0,
                                height: 20.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21.0),
                  Text(
                    'Country',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 14.0, top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: const Color.fromRGBO(219, 219, 219, 0.2)),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4.0),
                          blurRadius: 4.0,
                          color: Color.fromRGBO(229, 220, 229, 0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Please Select',
                            style: kBodyTextStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Image.asset(
                          'images/icon/down.png',
                          width: 20.0,
                          height: 20.0,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 21.0),
                  Text(
                    'Contact Number',
                    style: kLabelTextStyle.copyWith(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: const Color.fromRGBO(219, 219, 219, 0.2)),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4.0),
                              blurRadius: 4.0,
                              color: Color.fromRGBO(229, 220, 229, 0.1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '+60',
                            style: kBodyTextStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: validate,
                          validator: ValidationBuilder().required('Contact Number is required').minLength(1, 'Contact Number is required').build(),
                          controller: txtcontact,
                          cursorColor: const Color(0xFF002E50),
                          style: const TextStyle(
                            fontFamily: kBodyFont,
                            fontSize: 16.0,
                            color: Color(0xFF002E50),
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15.0),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'e.g 123338888',
                            hintStyle: kBodyTextStyle.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB1B1B1),
                            ),
                            errorStyle: const TextStyle(
                              fontFamily: kBodyFont,
                              color: Color(0xFFFA4954),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color.fromRGBO(219, 219, 219, 0.2)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color(0xFFFA4954)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(color: Color(0xFFFA4954)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 110.0),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 42.0),
            color: const Color(0xFFF8F8F8),
            child: ElevatedButton(
              onPressed: !isValid ? null : () {
                
              },
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
              child: Text(
                'Save',
                style: kMainTextStyle.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Add Billing Details',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: buildForm(),
        ),
      ),
    );
  }
}