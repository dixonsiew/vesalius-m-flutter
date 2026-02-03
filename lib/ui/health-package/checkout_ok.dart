import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/ui/guest.dart';
import 'package:vesalius_m_flutter/ui/main_layout.dart';
import 'package:vesalius_m_flutter/ui/services/doctor.dart';

class CheckoutOK extends StatefulWidget {
  
  static const String routeName = '/CheckoutOK';

  const CheckoutOK({super.key});

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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/icon/tick3.png',
                  width: 72.0,
                  height: 72.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Transaction Success!',
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Your order was placed successfully. For more details, check My Screening Packages under Profile Tab.',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB1B1B1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppElevatedButton(
                  text: 'Make Appointment',
                  onPressed: () {
                    Get.offUntil(GetPageRoute(page: () => const Doctor()), (route) => (route as GetPageRoute).routeName == MainLayout.routeName);
                  },
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Later',
                  onPressed: () {
                    if (AuthManager.isLogin) {
                      Get.until((route) => Get.currentRoute == MainLayout.routeName);
                    }
                        
                    else {
                      Get.until((route) => Get.currentRoute == Guest.routeName);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: '',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}