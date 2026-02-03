import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/bottom_bar.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/ui/appointment/completed.dart';
import 'package:vesalius_m_flutter/ui/appointment/upcoming.dart';
import 'package:vesalius_m_flutter/ui/doctor.dart';

class Appointment extends StatefulWidget {

  static const String routeName = '/Appointment';

  final int? tabIndex;

  const Appointment({
    Key? key, 
    this.tabIndex,
  }) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> with SingleTickerProviderStateMixin {

  int tabIndex = 0;
  late TabController tabController;
  List<FutureAppointment> list = [];

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
    tabIndex = widget.tabIndex ?? 0;
    tabController.index = tabIndex;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    tabController.removeListener(() { });
    super.dispose();
  }

  Future<bool> onWillPop() async {
    return await showConfirmDialog('Are you sure you want to exit ?');
  }

  String getTime(String s) {
    var a = s.split(':');
    int hour = int.parse(a[0]);
    int min = int.parse(a[1]);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, min);
    return formatDate(dt, [hh, ':', nn, ' ', am]);
  }

  String getDate(String s) {
    return s.replaceAll('-', ' ');
  }

  Widget buildMakeAppointment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: RawMaterialButton(
        elevation: 5.0,
        fillColor: kAppointmentBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
        child: const Text(
          'Make Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kBodyFont,
          ),
        ),
        onPressed: () {
          Get.toNamed(Doctor.routeName);
        },
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Container(
            width: 80.0,
            height: 60.0,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage('images/icon/page-header-icon/appointment.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0, top: 30.0),
            child: Text(
              'Schedule your Appointment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: kTitleFont,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayer2() {
    var padding = MediaQuery.of(context).padding;

    return SizedBox(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            buildHeader(),
            Flexible(
              child: buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLayer1() {
    return Container(
      width: double.infinity,
      height: 160.0,
      color: kAppointmentBgColor,
    );
  }

  Widget buildContent() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
                toolbarHeight: kAppToolbarHeight + 44,
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFFF8F8F8),
                centerTitle: false,
                title: Text(
                  'Appointment',
                  style: kMainTextStyle.copyWith(
                    fontSize: 24.0,
                    color: kMainColor,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: Image.asset(
                        'images/icon/plus.png',
                        width: 24.0,
                        height: 24.0,
                        fit: BoxFit.cover,
                      ),
                      onPressed: () {
                        Get.toNamed(Doctor.routeName);
                      },
                    ),
                  ),
                ],
                elevation: 0.0,
                bottom: TabBar(
                  indicatorColor: Colors.transparent,
                  controller: tabController,
                  onTap: (int i) {
                    setState(() {
                      tabIndex = i;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 11.0),
                        decoration: BoxDecoration(
                          color: tabIndex == 0 ? kMainColor : const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text(
                          context.watch<AppointmentModel>().appointmentCount > 0 ? 'Upcoming (${context.watch<AppointmentModel>().appointmentCount})' : 'Upcoming',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            color: tabIndex == 0 ? Colors.white : const Color(0xFFB1B1B1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 11.0),
                        decoration: BoxDecoration(
                          color: tabIndex == 1 ? kMainColor : const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Text(
                          'Completed',
                          style: kMainTextStyle.copyWith(
                            fontSize: 16.0,
                            color: tabIndex == 1 ? Colors.white : const Color(0xFFB1B1B1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: const Color(0xFFF8F8F8),
              body: SafeArea(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    UpcomingAppointment(),
                    CompletedAppointment(),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomBar(index: 1),
            );
          }
        ),
      ),
    );
  }
}