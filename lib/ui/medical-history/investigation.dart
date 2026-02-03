import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/data-label.dart';
import 'package:vesalius_m_flutter/components/medical-info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';

class Investigation extends StatefulWidget {
  
  static final String routeName = 'Investigation';

  final PatientVisit patientVisit;

  Investigation({
    @required this.patientVisit,
  });

  @override
  _InvestigationState createState() => _InvestigationState();
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
      String s = o.investigationType.toLowerCase();
      if (map.containsKey(s)) {
        var ls = map[s];
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
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ) +
        Border(
          bottom: BorderSide(
            color: Color.fromRGBO(224, 224, 224, 0.599),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: kPrimaryBtnBgColor,
          fontSize: 16.0,
        ),
      ),
    );
  }

  void buildRadiologyService(List<Widget> lx) {
    final ls = map['radiology services'];
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lk.addAll([
        SizedBox(height: 10.0),
        Text(
          o.description,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: 5.0),
        Html(
          data: o.resultClob,
          style: {
            'html': Style(
              fontSize: FontSize(16.0, units: 'pt'),
            ),
          },
        ),
      ]);
    }

    lx.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  void buildDiagnosticInvest(List<Widget> lx) {
    final ls = map['diagnostic investigation'];
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lk.addAll([
        SizedBox(height: 10.0),
        Text(
          o.description,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: 5.0),
        Html(
          data: o.resultClob,
          style: {
            'html': Style(
              fontSize: FontSize(16.0, units: 'pt'),
            ),
          },
        ),
      ]);
    }

    lx.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  void buildClinicalMeasurement(List<Widget> lx) {
    final ls = map['clincial measurement'];
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      lk.addAll([
        SizedBox(height: 10.0),
        DataLabel(
          label: 'Description: ',
          data: o.description,
        ),
        SizedBox(height: 5.0),
        DataLabel(
          label: 'Result / Unit: ',
          data: o.resultValue == null ? '-' : '${o.resultValue} ${o.resultUnit}'
        ),
        SizedBox(height: 10.0),
      ]);
    }

    lx.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: lk,
        ),
      )
    );
  }

  void buildLabService(List<Widget> lx) {
    final ls = map['lab services'];
    List<Widget> lk = [];
    for (int i = 0; i < ls.length; i++) {
      var o = ls[i];
      if (o.description != null) {
        lk.addAll([
          SizedBox(height: 10.0),
          DataLabel(
            label: 'Description: ',
            data: o.description,
          ),
          SizedBox(height: 5.0),
          DataLabel(
            label: 'Result / Unit: ',
            data: o.resultValue == null ? '-' : '${o.resultValue} ${o.resultUnit}'
          ),
          SizedBox(height: 5.0),
          DataLabel(
            label: 'Ref. Range: ',
            data: o.referenceRange ?? '-'
          ),
          SizedBox(height: 10.0),
        ]);
      }

      if (o.panelDescription != null) {
        lk.addAll([
          SizedBox(height: 10.0),
          Text(
            o.panelDescription,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ]);
      }

      if (o.panelDetail != null) {
        for (int j = 0; j < o.panelDetail.length; j++) {
          var x = o.panelDetail[j];
          lk.addAll([
            SizedBox(height: 10.0),
            DataLabel(
              label: 'Description: ',
              data: x.description,
            ),
            SizedBox(height: 5.0),
          ]);

          if (x.resultClob != null) {
            lk.add(
              Html(
                data: x.resultClob,
                style: {
                  'html': Style(
                    fontSize: FontSize(16.0, units: 'pt'),
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
              SizedBox(height: 5.0),
              DataLabel(
                label: 'Ref. Range: ',
                data: x.referenceRange ?? '-'
              ),
              SizedBox(height: 10.0),
            ]);
          }
        }
      }
    }

    lx.add(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: BackBtn(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Investigation',
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