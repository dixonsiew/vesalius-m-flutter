import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/vital-signs/height-chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

class Height extends StatefulWidget {
  
  static const String routeName = 'VitalSigns/HT';

  final String date;

  Height({
    required this.date,
  });

  @override
  _HeightState createState() => _HeightState();
}

class _HeightState extends State<Height> {
  
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
      var lx = await getVitalSignHistory('HEIGHT', branchDetails!.branch!.branchId!, branchDetails.prn!, widget.date);
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
          Divider(
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
      padding: EdgeInsets.only(top: 20.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'History (Last ${list.length})',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: kTitleFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
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
      padding: EdgeInsets.only(left: 10.0, right: 15.0, top: 10.0, bottom: 10.0),
      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height - 90.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD6D6D6),
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromRGBO(191, 191, 191, 1),
            offset: Offset(0, 2),
            blurRadius: 7.0,
            spreadRadius: -1,
          ),
        ]
      ),
      child: HeightChart(list: list),
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
        progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
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

  HistoryItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data.recordedDate ?? '',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: kBodyFont,
              color: Color(0xFF727272),
            ),
          ),
          Text(
            '${data.value1} cm',
            style: TextStyle(
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