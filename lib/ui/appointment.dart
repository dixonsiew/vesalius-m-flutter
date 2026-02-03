import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/edit_appointment.dart';
import 'package:vesalius_m_flutter/ui/doctor.dart';

class Appointment extends StatefulWidget {

  static const String routeName = 'Appointment';

  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {

  List<FutureAppointment> list = [];
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
      var branchDetails = DataManager.branchDetails;
      var lx = await getVesaliusFutureAppointments(branchDetails!.branch!.branchId!, branchDetails.prn!);
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
      itemBuilder: (context, i) {
        final o = list[i];
        return AppointmentItem(
          date: getDate(o.date!),
          startTime: getTime(o.startTime!),
          doctorName: o.doctorName ?? '',
          appointment: o,
          load: load,
        );
      }, 
      separatorBuilder: (context, i) => const Divider(
        color: Color(0xFFE2E2E2),
        height: 1.0,
        thickness: 1.0,
      ), 
      itemCount: list.length,
    );
  }

  Widget buildMakeAppointment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: RawMaterialButton(
        elevation: 5.0,
        fillColor: kHomeBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        constraints: const BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
        child: const Text(
          'Make Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kBodyFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, Doctor.routeName);
        },
      ),
    );
  }

  Widget _buildContent() {
    if (list.isEmpty) {
      return ListView(
        shrinkWrap: true,
        children: const [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'You do not have any upcoming appointments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF727272),
                fontSize: 16.0,
                fontFamily: kBodyFont,
              ),
            ),
          ),
        ],
      );
    }

    return Scrollbar(
      child: buildList(),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return Container(
      margin: const EdgeInsets.only(top: 40.0),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(133, 133, 133, 0.29),
            offset: Offset(5, 4),
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: onRefresh,
        color: kPrimaryColor,
        child: _buildContent(),
      ),
    ); 
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'images/icon/page-header-icon/appointment.png',
            width: 65.0,
            height: 50.0,
            fit: BoxFit.contain,
          ),
          const Flexible(
            child: Text(
              'Schedule your Appointment',
              style: TextStyle(
                color: Color(0xFF565758),
                fontSize: 20.0,
                fontFamily: kTitleFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLayer2xx() {
    var padding = MediaQuery.of(context).padding;

    return SizedBox(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom - 70.0,
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

  Widget buildLayer2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          buildHeader(),
          Flexible(
            child: buildContent(),
          ),
        ],
      ),
    );
  }

  Widget buildLayer1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 160.0,
          color: kAppointmentBgColor,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kAppointmentBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kAppointmentBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Color(0xFF565758)),
        elevation: 0.0,
      ),
      backgroundColor: kAppointmentBgColor,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: Stack(
            children: [
              buildLayer1(),
              buildLayer2(),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildMakeAppointment(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentItem extends StatelessWidget {

  final String date;
  final String startTime;
  final String doctorName;
  final FutureAppointment appointment;
  final void Function() load;

  const AppointmentItem({
    Key? key,
    required this.date,
    required this.startTime,
    required this.doctorName,
    required this.appointment,
    required this.load,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final b = await Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => EditAppointment(appointment: appointment),
          )
        );
        if (b == true) {
          load();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: kBodyFont,
                      color: Color(0xFF727272),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: kBodyFont,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 5.0),
                Text(
                  startTime,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontFamily: kBodyFont,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xFF565758),
                  size: 18.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}