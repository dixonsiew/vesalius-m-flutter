import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/ui/services/doctor.dart';

import 'appointment/completed_appointment.dart';
import 'appointment/upcoming_appointment.dart';

class Appointment extends StatefulWidget {

  static const String routeName = '/Appointment';

  final int tabIndex;

  const Appointment({
    super.key, 
    this.tabIndex = 0,
  });

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Appointment> {

  int tabIndex = 0;
  late TabController tabController;

  final UpcomingAppointmentCtrl upcomingAppointmentCtrl = Get.put(UpcomingAppointmentCtrl());

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
    tabIndex = widget.tabIndex;
    tabController.index = tabIndex;
  }

  @override
  void dispose() {
    tabController.removeListener(() { });
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
              toolbarHeight: kAppToolbarHeight,
              automaticallyImplyLeading: false,
              backgroundColor: kBgColor1,
              centerTitle: true,
              title: Text(
                'Appointment',
                style: kTextStyle1.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: kTextColor1,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => const Doctor());
                    },
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
              elevation: 2.0,
              bottom: TabBar(
                indicatorColor: kPrimaryColor,
                controller: tabController,
                onTap: (int i) {
                  setState(() {
                    tabIndex = i;
                  });
                },
                tabs: [
                  Tab(
                    child: Obx(() =>
                      Text(
                        upcomingAppointmentCtrl.count == 0 ? 'Upcoming' : 'Upcoming (${upcomingAppointmentCtrl.count})',
                        //context.watch<AppointmentModel>().appointmentCount > 0 ? 'Upcoming (${context.watch<AppointmentModel>().appointmentCount})' : 'Upcoming',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: tabIndex == 0 ? kPrimaryColor : kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Completed',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: tabIndex == 1 ? kPrimaryColor : kTextColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: kBgColor1,
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: const [
                  UpcomingAppointment(),
                  CompletedAppointment(),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}