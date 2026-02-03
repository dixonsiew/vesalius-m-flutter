import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/vital-signs/bp_chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class BP extends StatefulWidget {

  final String date;

  const BP({
    Key? key, 
    required this.date,
  }) : super(key: key);

  @override
  State<BP> createState() => _BPState();
}

class _BPState extends State<BP> {

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
      var lx = await getVitalSignHistory('BP', branchDetails!.branch!.branchId!, branchDetails.prn!, widget.date);
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
            color: Color.fromRGBO(219, 219, 219, 0.45),
            thickness: 1.0,
          )
        );
      }
    }

    return lx;
  }

  Widget buildList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 15.0),
            child: Text(
              'History (Last ${list.length})',
              style: kTitleTextStyle.copyWith(
                fontSize: 16.0,
                color: kMainColor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25.0),
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 19.0, bottom: 19.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(229, 229, 229, 0.7),
                  blurRadius: 7.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: buildListItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChart() {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 30.0),
      padding: const EdgeInsets.only(left: 10.0, right: 15.0, top: 10.0, bottom: 10.0),
      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height - 90.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(236, 238, 255, 0.8),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: BPChart(list: list),
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildChart(),
        buildList(),
      ],
    );
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
          'Blood Pressure',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: buildContent(),
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
    Key? key, 
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          data.recordedDate ?? '',
          style: kMainTextStyle.copyWith(
            fontFamily: kBodyFont,
          ),
        ),
        Text(
          '${data.value1}/${data.value2} mmHg',
          style: kTitleTextStyle.copyWith(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}