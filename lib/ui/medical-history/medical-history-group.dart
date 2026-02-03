import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';
import 'package:vesalius_m_flutter/ui/medical-history/health-screen-rpt.dart';
import 'package:vesalius_m_flutter/ui/medical-history/investigation.dart';
import 'package:vesalius_m_flutter/ui/medical-history/referral-letter.dart';

import 'bill-summary.dart';

class MedicalHistoryGroup extends StatefulWidget {
  
  static final String routeName = 'MedicalHistoryGroup';

  final String title;
  final int pageId;

  MedicalHistoryGroup({
    @required this.title,
    @required this.pageId,
  });

  @override
  _MedicalHistoryGroupState createState() => _MedicalHistoryGroupState();
}

class _MedicalHistoryGroupState extends State<MedicalHistoryGroup> {

  List<PatientVisit> list = [];
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
      var lx = await getVesaliusPatientVisit(branchDetails.branch.branchId, branchDetails.prn, widget.pageId);
      await sortList(lx);
      await DataManager.setItem('patientVisit-${widget.pageId}', list);
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

  Future<void> sortList(List<PatientVisit> lx) async {
    lx.sort((a, b) {
      DateTime dt1 = DateTime.parse(a.novaVisit.registrationDate);
      DateTime dt2 = DateTime.parse(b.novaVisit.registrationDate);
      return dt2.compareTo(dt1);
    });
    setState(() {
      list = lx;
      isLoading = false;
    });
  }

  String getDate(PatientVisit o) {
    DateTime dt = DateTime.parse(o.novaVisit.registrationDate);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  void onItemTap(PatientVisit o) {
    if (widget.pageId == 4) {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => BillSummary(
            patientVisit: o,
          ),
        )
      );
    }

    else if (widget.pageId == 3) {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => Investigation(
            patientVisit: o,
          )
        )
      );
    }

    else if (widget.pageId == 6) {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => ReferralLetter(
            patientVisit: o,
          )
        )
      );
    }

    else if (widget.pageId == 7) {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => HealthScreenRpt(
            patientVisit: o,
          )
        )
      );
    }
  }

  Widget buildList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, i) {
        final o = list[i];
        return MedicalHistoryGroupItem(
          date: getDate(o),
          type: o.novaVisit.visitType,
          onTap: () {
            onItemTap(o);
          },
        );
      }, 
      separatorBuilder: (context, i) => Divider(
        color: Color(0xFFE2E2E2),
        height: 1.0,
        thickness: 1.0,
      ),
    );
  }

  Widget _buildContent() {
    if (list.isEmpty) {
      String s = 'You do not have any past medical history at the moment.';
      if (widget.pageId == 2) {
        s = 'You do not have any past information at the moment.';
      }

      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              s,
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
                image: AssetImage('images/icon/page-header-icon/medical-record.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0, top: 25.0),
            child: Text(
              widget.title,
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
      color: kMedicalRecordBgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
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
    );
  }
}

class MedicalHistoryGroupItem extends StatelessWidget {
  
  final String date;
  final String type;
  final void Function() onTap;

  MedicalHistoryGroupItem({
    @required this.date,
    @required this.type,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 25.0, bottom: 25.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$date',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF727272),
                ),
              ),
            ),
            Expanded(
              child: Text(
                '$type',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Color(0xFFBBBBBB),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: kMedicalRecordBgColor,
            ),
          ],
        ),
      ),
    );
  }
}