import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/data-label.dart';
import 'package:vesalius_m_flutter/components/medical-info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

class HealthScreenRpt extends StatelessWidget {

  static final String routeName = 'HealthScreenRpt';

  final PatientVisit patientVisit;

  HealthScreenRpt({
    @required this.patientVisit,
  });

  Widget buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: buildContentList(),
      ),
    );
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < patientVisit.novaHealthScreeningRptList.length; i++) {
      final o = patientVisit.novaHealthScreeningRptList[i];
      lx.add(
        HealthScreenRptItem(novaHealthScreeningRpt: o)
      );
    }

    return lx;
  }

  Widget buildHeader() {
    return MedicalInfo(
      patientVisit: patientVisit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Health Screening Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(),
                buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HealthScreenRptItem extends StatefulWidget {
  
  final NovaHealthScreeningRpt novaHealthScreeningRpt;

  HealthScreenRptItem({
    @required this.novaHealthScreeningRpt,
  });

  @override
  _HealthScreenRptItemState createState() => _HealthScreenRptItemState();
}

class _HealthScreenRptItemState extends State<HealthScreenRptItem> {

  bool isDownloading = false;
  double percent;

  String getDate() {
    DateTime dt = DateFormat('y-M-d').parse(widget.novaHealthScreeningRpt.reportDate.substring(0, 10));
    return formatDate(dt, [dd, ' ', M, ' ', yyyy]);
  }

  void onViewReport() async {
    setState(() {
      isDownloading = true;
      percent = 0;
    });
    var branchDetails = DataManager.branchDetails;
    var dir = await getApplicationDocumentsDirectory();
    String fp = '${dir.path}/${widget.novaHealthScreeningRpt.hsrRefNo}.pdf';
    File file = await getHealthScrReportPdf(branchDetails.branch.branchId, widget.novaHealthScreeningRpt.hsrRefNo, fp, (received, total) {
      if (total != -1) {
        double pct = (received / total * 100);
        setState(() {
          percent = pct;
        });
        
        //print((received / total * 100).toStringAsFixed(0) + "%");
      }
    });
    setState(() {
      isDownloading = false;
    });
    //print(file.path);
    await OpenFile.open(file.path);
  }

  List<Widget> buildList() {
    final o = widget.novaHealthScreeningRpt;
    List<Widget> lx = [];
    lx.addAll([
      SizedBox(height: 10.0),
      DataLabel(
        label: 'Report By: ',
        data: o.reportUser ?? '-',
      ),
      SizedBox(height: 5.0),
      DataLabel(
        label: 'Report Date: ',
        data: getDate() ?? '-',
      ),
      SizedBox(height: 5.0),
      RawMaterialButton(
        elevation: 5.0,
        fillColor: kMedicalRecordBgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        constraints: BoxConstraints(minWidth: double.maxFinite, minHeight: 50.0),
        child: Text(
          'View Report',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        onPressed: onViewReport,
      ),
      SizedBox(height: isDownloading ? 5.0 : 10.0),
    ]);
    if (isDownloading) {
      lx.addAll([
        LinearPercentIndicator(
          lineHeight: 14.0,
          percent: (percent ?? 0) / 100.0,
          center: Text(
            '${percent?.toStringAsFixed(0) ?? 0} %',
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          linearStrokeCap: LinearStrokeCap.roundAll,
          backgroundColor: Colors.grey,
          progressColor: kMedicalRecordBgColor,
        ),
        SizedBox(height: 10.0),
      ]);
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: buildList(),
    );
  }
}