import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/vital-signs/bmi_chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class BMI extends StatefulWidget {
  
  static const String routeName = 'VitalSigns/BMI';

  final String date;

  const BMI({
    super.key, 
    required this.date,
  });

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {

  List<VitalSignsData> list = [];
  bool isLoading = false;

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
      var lx = await getVitalSignHistory('BMI', branchDetails!.branch!.branchId!, branchDetails.prn!, widget.date);
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

  List<Widget> buildListItem() {
    List<Widget> lx = [];
    for (int i = 0; i < list.length; i++) {
      lx.add(HistoryItem(data: list[i].novaPatientVitalSignsDetail!));
      if (i < list.length - 1) {
        lx.add(
          const Divider(
            color: Color(0xFFE2E2E2),
            height: 1.0,
            thickness: 1.0,
          )
        );
      }
    }

    return lx;
  }

  Widget buildList() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: kMedicalRecordBgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'History (Last ${list.length})',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: kTitleFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(133, 133, 133, 0.29),
                      offset: Offset(5, 4),
                      blurRadius: 10.0,
                      spreadRadius: 1,
                    ),
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: buildListItem(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 15.0, top: 10.0, bottom: 10.0),
      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height - 90.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD6D6D6),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(191, 191, 191, 1),
            offset: Offset(0, 2),
            blurRadius: 7.0,
            spreadRadius: -1,
          ),
        ]
      ),
      child: BMIChart(list: list),
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
          'Vital Signs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: kTitleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
        child: SafeArea(
          child: isLoading ? Container() : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildChart(),
                  buildList(),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  
  final NovaPatientVitalSignsDetail data;

  const HistoryItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data.recordedDate ?? '',
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: kBodyFont,
              color: Color(0xFF727272),
            ),
          ),
          Text(
            data.value1 ?? '',
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: kBodyFont,
              color: Color(0xFF727272),
            ),
          ),
        ],
      ),
    );
  }
}