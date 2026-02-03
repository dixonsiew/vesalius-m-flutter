import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/appointment.dart';
import 'package:vesalius_m_flutter/ui/home.dart';
import 'package:vesalius_m_flutter/ui/profile.dart';

class BottomBar extends StatefulWidget {

  final int index;

  const BottomBar({
    Key? key, 
    required this.index,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    final navBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            widget.index == 0 ? 'images/icon/home.png' : 'images/icon/home0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            widget.index == 1 ? 'images/icon/appointment.png' : 'images/icon/appointment0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Appointment',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
          child: Image.asset(
            widget.index == 2 ? 'images/icon/profile.png' : 'images/icon/profile0.png',
            width: 16.0,
            height: 16.0,
            fit: BoxFit.cover,
          ),
        ),
        label: 'Profile',
      ),
    ];
    final navBar = BottomNavigationBar(
      backgroundColor: kMainColor,
      selectedLabelStyle: const TextStyle(
        fontFamily: kTitleFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.05,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: kTitleFont,
        fontSize: 12.0,
        fontWeight: FontWeight.w800,
        color: Color.fromRGBO(255, 255, 255, 0.65),
        letterSpacing: 0.05,
      ),
      items: navBarItems,
      currentIndex: widget.index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.65),
      onTap: (int i) {
        if (i == 0 && widget.index != i) {
          Get.offAllNamed(Home.routeName);
        }

        else if (i == 1 && widget.index != i) {
          Get.offAllNamed(Appointment.routeName);
        }

        else if (i == 2 && widget.index != i) {
          Get.offAllNamed(Profile.routeName);
        }

        // else if (i == 3 && widget.index != i) {
        //   Navigator.pushNamedAndRemoveUntil(context, Notifications.routeName, (route) => false);
        // }
      },
    );

    return Material(
      elevation: 5.0,
      color: kMainColor,
      child: navBar,
    );
  }
}