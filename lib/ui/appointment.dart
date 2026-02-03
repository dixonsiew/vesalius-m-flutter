import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment-data.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';
import 'package:vesalius_m_flutter/ui/appointment/edit-appointment.dart';
import 'package:vesalius_m_flutter/ui/doctor.dart';

class Appointment extends StatefulWidget {

  static final String routeName = 'Appointment';

  @override
  _AppointmentState createState() => _AppointmentState();
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
      var lx = await getVesaliusFutureAppointments(branchDetails.branch.branchId, branchDetails.prn);
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
          date: getDate(o.date),
          startTime: getTime(o.startTime),
          doctorName: o.doctorName,
          appointment: o,
          load: load,
        );
      }, 
      separatorBuilder: (context, i) => Divider(
        color: Color(0xFFE2E2E2),
        height: 1.0,
        thickness: 1.0,
      ), 
      itemCount: list.length,
    );
  }

  Widget buildMakeAppointment() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: RawMaterialButton(
        elevation: 5.0,
        fillColor: kAppointmentBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
        child: Text(
          'Make Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
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
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'You do not have any upcoming appointments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF727272),
                fontSize: 16.0,
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
      margin: EdgeInsets.only(top: 40.0),
      width: double.infinity,
      decoration: BoxDecoration(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Container(
            width: 80.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage('images/icon/page-header-icon/appointment.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0, top: 30.0),
            child: Text(
              'Schedule your Appointment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayer2() {
    var padding = MediaQuery.of(context).padding;

    return Container(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kAppointmentBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kAppointmentBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: Stack(
            children: [
              buildLayer1(),
              buildLayer2(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        buildMakeAppointment(),
      ],
    );
  }
}

class AppointmentItem extends StatelessWidget {

  final String date;
  final String startTime;
  final String doctorName;
  final FutureAppointment appointment;
  final void Function() load;

  AppointmentItem({
    @required this.date,
    @required this.startTime,
    @required this.doctorName,
    @required this.appointment,
    @required this.load,
  });

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
        padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 15.0, bottom: 15.0),
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
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF727272),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      doctorName,
                      style: TextStyle(
                        fontSize: 16.0,
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
                SizedBox(width: 5.0),
                Text(
                  startTime,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.black,
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