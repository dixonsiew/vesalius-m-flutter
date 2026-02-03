import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';

class Investigation extends StatefulWidget {
  
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
    final lx = widget.patientVisit.novaVisitInvestigationDetailList ?? [];
    for (int i = 0; i < lx.length; i++) {
      final o = lx[i];
      String s = o.investigationType!.toLowerCase();
      if (map.containsKey(s)) {
        List<NovaVisitInvestigationDetail> ls = map[s]!;
        ls.add(o);
      }

      else {
        List<NovaVisitInvestigationDetail> ls = [o];
        map[s] = ls;
        investigationTypeList.add(s);
      }
    }
  }

  Widget buildContent() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Investigation',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}