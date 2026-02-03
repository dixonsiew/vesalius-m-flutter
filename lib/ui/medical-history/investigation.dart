import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/data_label.dart';
import 'package:vesalius_m_flutter/components/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class Investigation extends StatefulWidget {
  
  static const String routeName = 'Investigation';

  final PatientVisit patientVisit;

  const Investigation({
    Key? key,
    required this.patientVisit,
  }) : super(key: key);

  @override
  State<Investigation> createState() => _InvestigationState();
}

class _InvestigationState extends State<Investigation> {

  Map<String, List<NovaVisitInvestigationDetail>> map = {};
  List<String> investigationTypeList = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    var lx = widget.patientVisit.novaVisitInvestigationDetailList ?? [];
    for (int i = 0; i < lx.length; i++) {
      final o = lx[i];
      String s = o.investigationType?.toLowerCase() ?? '';
      if (map.containsKey(s)) {
        var ls = map[s]!;
        ls.add(o);
      }

      else {
        List<NovaVisitInvestigationDetail> ls = [o];
        map[s] = ls;
        investigationTypeList.add(s);
      }
    }
  }

  Widget buildRowHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: kPrimaryBtnBgColor,
          fontSize: 16.0,
          fontFamily: kBodyFont,
        ),
      ),
    );
  }

  void buildRadiologyService(List<Widget> lx) {
    final ls = map['radiology services']!;
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lk.addAll([
        const SizedBox(height: 10.0),
        Text(
          o.description ?? '',
          style: const TextStyle(
            fontSize: 15.0,
            fontFamily: kBodyFont,
          ),
        ),
        const SizedBox(height: 5.0),
        Html(
          data: o.resultValue == null && o.resultClob == null ? 'Result in PDF format. Unable to view now' : o.resultClob,
          style: {
            'html': Style(
              fontSize: FontSize(16.0),
              fontFamily: kBodyFont,
            ),
          },
        ),
      ]);
    }

    lx.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  void buildDiagnosticInvest(List<Widget> lx) {
    final ls = map['diagnostic investigation']!;
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lk.addAll([
        const SizedBox(height: 10.0),
        Text(
          o.description ?? '',
          style: const TextStyle(
            fontSize: 15.0,
            fontFamily: kBodyFont,
          ),
        ),
        const SizedBox(height: 5.0),
        Html(
          data: o.resultValue == null && o.resultClob == null ? 'Result in PDF format. Unable to view now' : o.resultClob,
          style: {
            'html': Style(
              fontSize: FontSize(16.0),
              fontFamily: kBodyFont,
            ),
          },
        ),
      ]);
    }

    lx.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  void buildClinicalMeasurement(List<Widget> lx) {
    final ls = map['clincial measurement']!;
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lk.addAll([
        const SizedBox(height: 10.0),
        DataLabel(
          label: 'Description: ',
          data: o.description ?? '',
        ),
        const SizedBox(height: 5.0),
        DataLabel(
          label: 'Result / Unit: ',
          data: o.resultValue == null ? '-' : '${o.resultValue} ${o.resultUnit}'
        ),
        const SizedBox(height: 10.0),
      ]);
    }

    lx.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  void buildLabService(List<Widget> lx) {
    final ls = map['lab services']!;
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      if (o.description != null) {
        lk.addAll([
          const SizedBox(height: 10.0),
          DataLabel(
            label: 'Description: ',
            data: o.description ?? '',
          ),
          const SizedBox(height: 5.0),
          DataLabel(
            label: 'Result / Unit: ',
            data: o.resultValue == null ? '-' : '${o.resultValue} ${o.resultUnit}'
          ),
          const SizedBox(height: 5.0),
          DataLabel(
            label: 'Ref. Range: ',
            data: o.referenceRange ?? '-'
          ),
          const SizedBox(height: 10.0),
        ]);
      }

      if (o.panelDescription != null) {
        lk.addAll([
          const SizedBox(height: 10.0),
          Text(
            o.panelDescription ?? '',
            style: const TextStyle(
              fontSize: 15.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ]);
      }

      if (o.panelDetail != null) {
        for (int j = 0; j < o.panelDetail!.length; j++) {
          var x = o.panelDetail![j];
          lk.addAll([
            const SizedBox(height: 10.0),
            DataLabel(
              label: 'Description: ',
              data: x.description ?? '',
            ),
            const SizedBox(height: 5.0),
          ]);

          if (x.resultClob != null) {
            lk.add(
              Html(
                data: x.resultClob ?? '',
                style: {
                  'html': Style(
                    fontSize: FontSize(16.0),
                    fontFamily: kBodyFont,
                  ),
                },
              )
            );
          }

          if (x.resultClob == null) {
            lk.addAll([
              DataLabel(
                label: 'Result / Unit: ',
                data: x.resultValue == null ? '-' : '${x.resultValue} ${x.resultUnit}'
              ),
              const SizedBox(height: 5.0),
              DataLabel(
                label: 'Ref. Range: ',
                data: x.referenceRange ?? '-'
              ),
              const SizedBox(height: 10.0),
            ]);
          }
        }
      }
    }

    lx.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  List<Widget> buildContentList() {
    List<Widget> lx = [];
    for (int i = 0; i < investigationTypeList.length; i++) {
      if (investigationTypeList[i] == 'clincial measurement') {
        lx.add(buildRowHeader('Clincial Measurement'));
        buildClinicalMeasurement(lx);
      }

      if (investigationTypeList[i] == 'radiology services') {
        lx.add(buildRowHeader('Radiology Services'));
        buildRadiologyService(lx);
      }

      if (investigationTypeList[i] == 'diagnostic investigation') {
        lx.add(buildRowHeader('Diagnostic Investigation'));
        buildDiagnosticInvest(lx);
      }

      if (investigationTypeList[i] == 'lab services') {
        lx.add(buildRowHeader('Lab Services'));
        buildLabService(lx);
      }
    }

    return lx;
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildContentList(),
    );
  }

  Widget buildHeader() {
    return MedicalInfo(
      patientVisit: widget.patientVisit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Investigation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kTitleFont,
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