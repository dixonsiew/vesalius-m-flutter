import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';
import 'package:vesalius_m_flutter/ui/home.dart';

class CheckoutOK extends StatefulWidget {
  
  static const String routeName = '/CheckoutOK';

  const CheckoutOK({Key? key}) : super(key: key);

  @override
  State<CheckoutOK> createState() => _CheckoutOKState();
}

class _CheckoutOKState extends State<CheckoutOK> {

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.load();
  }

  Widget buildContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 45.0, right: 45.0, bottom: 154.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 72.0,
              height: 72.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24.0),
            Text(
              'Transaction Success!',
              style: kLabelTextStyle.copyWith(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your order was placed successfully.\nFor more details, check My Screening Packages under Profile Tab.',
              style: kLabelTextStyle.copyWith(
                fontSize: 16.0,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Stack(
          children: [
            buildContent(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 42.0),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: kMainColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      ),
                      child: Text(
                        'Make Appointment',
                        style: kMainTextStyle.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    OutlinedButton(
                      onPressed: () {
                        if (AuthManager.isLogin) {
                          Get.offAllNamed(Home.routeName);
                        }
                        
                        else {
                          Get.offAllNamed(Guest.routeName);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kMainColor,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        side: const BorderSide(
                          color: Color(0xFFDBDBDB),
                        ),
                      ),
                      child: Text(
                        'Later',
                        style: kMainTextStyle.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kMainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}