import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/appointment_model.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/doctor.dart';

class UpcomingAppointment extends StatefulWidget {

  const UpcomingAppointment({Key? key}) : super(key: key);

  @override
  State<UpcomingAppointment> createState() => _UpcomingAppointmentState();
}

class _UpcomingAppointmentState extends State<UpcomingAppointment> with AutomaticKeepAliveClientMixin<UpcomingAppointment> {

  List<FutureAppointment> list = [];
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      final ctx = context.read<AppointmentModel>();
      var branchDetails = DataManager.branchDetails;
      var lx = await getVesaliusFutureAppointments(branchDetails!.branch!.branchId!, branchDetails.prn!);
      ctx.setAppointmentCount(lx.length);
      setState(() {
        list = lx;
        isLoading = false;
      });
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onRefresh() async {
    load();
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

  Widget buildList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: list.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) {
          return const SizedBox(height: 30.0);
        }

        else if (i == list.length + 1) {
          return const Spacer();
        }
        
        final o = list[i - 1];
        return Container(
          margin: const EdgeInsets.only(left: 25.0, right: 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(219, 219, 219, 0.6),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/icon/clock2.png',
                      width: 14.0,
                      height: 14.0,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${getDate(o.date!)}, ${getTime(o.startTime!)}',
                        style: kMainTextStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kMainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: Color.fromRGBO(218, 218, 218, 0.45),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/imgs/pic.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.doctorName!,
                            style: kMainTextStyle.copyWith(
                              fontFamily: kBodyFont,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            o.specialty!,
                            style: kMainTextStyle.copyWith(
                              fontFamily: kBodyFont,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'images/icon/location2.png',
                                width: 10.0,
                                height: 10.0,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Room 212, Level 2',
                                style: kMainTextStyle.copyWith(
                                  fontFamily: kBodyFont,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, i) => const SizedBox(
        height: 16.0,
      ),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    if (list.isEmpty) {
      return const NoAppointment();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: const Color(0xFFF8F8F8),
          height: MediaQuery.of(context).size.height - 320,
          child: Scrollbar(
            child: buildList(),
          ),
        ),
        Container(
          height: 80.0,
          margin: const EdgeInsets.only(left: 25.0, right: 25.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE1EDFF),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(229, 229, 229, 0.1),
                offset: Offset(0, 4.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                'images/icon/info.png',
                width: 16.0,
                height: 16.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 9.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need to reschedule / cancel appointment?',
                      style: kBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Call Customer Service.',
                      style: kLabelTextStyle.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFF002E50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kMainColor,
          child: buildContent(),
        ),
      ),
    );
  }
}

class NoAppointment extends StatelessWidget {

  const NoAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/medical-record.png',
            width: 96.0,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'You do not have any upcoming appointment at the moment.',
              style: kBodyTextStyle.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFB1B1B1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: OutlinedButton(
              onPressed: () {
                Get.toNamed(Doctor.routeName);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kMainColor,
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                side: const BorderSide(
                  color: kMainColor,
                ),
              ),
              child: Text(
                'Make An Appointment',
                style: kMainTextStyle.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kMainColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}