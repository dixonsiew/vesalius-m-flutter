import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/bill_summary/bill_summary.dart';

class HealthScreenRpt extends StatefulWidget {

  final PatientVisit patientVisit;

  const HealthScreenRpt({
    super.key,
    required this.patientVisit,
  });

  @override
  State<HealthScreenRpt> createState() => _HealthScreenRptState();
}

class _HealthScreenRptState extends State<HealthScreenRpt> {

  ScrollController scr = ScrollController();

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: Text(
          'Health Screening Report',
          style: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
      ),
    ];
    for (int i = 0; i < widget.patientVisit.novaHealthScreeningRptList.length; i++) {
      final NovaHealthScreeningRpt o = widget.patientVisit.novaHealthScreeningRptList[i];
      lx.add(HealthScreenRptItem(novaHealthScreeningRpt: o));
    }

    return lx;
  }

  Widget buildContent() {
    return Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          MedicalInfo(patientVisit: widget.patientVisit),
          const SizedBox(height: 32.0),
          ...buildContentList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Health Screening Report',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class HealthScreenRptItem extends StatefulWidget {

  final NovaHealthScreeningRpt novaHealthScreeningRpt;

  const HealthScreenRptItem({
    super.key,
    required this.novaHealthScreeningRpt,
  });

  @override
  State<HealthScreenRptItem> createState() => _HealthScreenRptItemState();
}

class _HealthScreenRptItemState extends State<HealthScreenRptItem> {

  bool isDownloading = false;
  double? percent;

  String get date {
    DateTime dt = DateFormat('y-M-d').parse(widget.novaHealthScreeningRpt.reportDate!.substring(0, 10));
    return formatDate(dt, [dd, ' ', M, ' ', yyyy]);
  }

  void onViewReport() async {
    setState(() {
      isDownloading = true;
      percent = 0;
    });
    var branchDetails = DataManager.instance.branchDetails;
    var dir = await getApplicationDocumentsDirectory();
    String fp = '${dir.path}/${widget.novaHealthScreeningRpt.hsrRefNo}.pdf';
    File file = await VesaliusService.getHealthScrReportPdf(branchDetails!.branch!.branchId!, widget.novaHealthScreeningRpt.hsrRefNo!, fp, (received, total) {
      if (total != -1) {
        double pct = (received / total * 100);
        setState(() {
          percent = pct;
        });
      }
    });
    setState(() {
      isDownloading = false;
    });
    //Get.to(() => PdfView(file: file));
    await OpenFilex.open(file.path);
  }

  List<Widget> buildContentList() {
    final NovaHealthScreeningRpt o = widget.novaHealthScreeningRpt;
    return [
      BillData(
        label: 'Report By',
        data: o.reportUser ?? '-',
      ),
      const SizedBox(height: 15.0),
      BillData(
        label: 'Report Date',
        data: date,
      ),
      const SizedBox(height: 25.0),
      OutlinedButton(
        onPressed: onViewReport,
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimaryColor,
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 40.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          side: const BorderSide(
            color: kPrimaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/icon/docs.png',
              width: 17.01,
              height: 16.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 21.52),
            Text(
              'View Report',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
      if (isDownloading) ...[
        const SizedBox(height: 5.0),
        LinearPercentIndicator(
          lineHeight: 16.0,
          percent: (percent ?? 0) / 100.0,
          center: Text(
            '${percent?.toStringAsFixed(0) ?? 0} %',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
          barRadius: const Radius.circular(16.0),
          backgroundColor: Colors.black26,
          progressColor: kPrimaryColor,
        ),
      ],
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kColor1.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 4.0),
            blurRadius: 7.0,
            color: kBgColor2.withValues(alpha: 0.7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: buildContentList(),
      ),
    );
  }
}