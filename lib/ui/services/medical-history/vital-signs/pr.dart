import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/history_item.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/pr_chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/medical-history/vital-signs/pr_ctrl.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

class PR extends StatefulWidget {
  
  final String date;

  const PR({
    super.key,
    required this.date,
  });

  @override
  State<PR> createState() => _PRState();
}

class _PRState extends State<PR> {

  ScrollController scr = ScrollController();
  final PRCtrl ctrl = Get.put(PRCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    scr.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      List<VitalSignsData> lx = await VesaliusService.getVitalSignHistory('PR', branchDetails!.branch!.branchId!, branchDetails.prn!, widget.date);
      ctrl.setList(lx);
      ctrl.setIsLoading(false);
    }

    catch (error) {
      ctrl.setIsLoading(false);
    }
  }

  List<Widget> buildListItem() {
    List<Widget> lx = [];
    for (int i = 0; i < ctrl.list.length; i++) {
      final NovaPatientVitalSignsDetail o = ctrl.list[i].novaPatientVitalSignsDetail!;
      lx.add(HistoryItem(
        recordedDate: o.recordedDate ?? '',
        val: o.value1 == null ? '' : '${o.value1} bpm',
      ));
      if (i < ctrl.list.length - 1) {
        lx.add(
          Divider(
            color: kColor1.withValues(alpha: 0.45),
            thickness: 1.0,
          )
        );
      }
    }

    return lx;
  }

  Widget buildList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'History (Last ${ctrl.list.length})',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: kBgColor2.withValues(alpha: 0.7),
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
    );
  }

  Widget buildChart() {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 30.0),
      padding: const EdgeInsets.only(left: 10.0, right: 15.0, top: 10.0, bottom: 10.0),
      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.33 : MediaQuery.of(context).size.height - 90.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: kColor1.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withValues(alpha: 0.5),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: PRChart(list: ctrl.list),
    );
  }

  Widget buildContent() {
    return ctrl.isLoading ? Container() : Scrollbar(
      controller: scr,
      child: ListView(
        controller: scr,
        shrinkWrap: true,
        children: [
          buildChart(),
          buildList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Pulse Rate',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}