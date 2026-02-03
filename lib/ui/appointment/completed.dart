import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/doctor.dart';

class CompletedAppointment extends StatefulWidget {

  const CompletedAppointment({Key? key}) : super(key: key);

  @override
  State<CompletedAppointment> createState() => _CompletedAppointmentState();
}

class _CompletedAppointmentState extends State<CompletedAppointment> with AutomaticKeepAliveClientMixin<CompletedAppointment> {

  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {

  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return const NoAppointment();
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
              'You do not have any completed appointment at the moment.',
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