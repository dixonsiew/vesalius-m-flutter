import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/medical-history/health_screen_rpt.dart';
import 'package:vesalius_m_flutter/ui/medical-history/investigation.dart';
import 'package:vesalius_m_flutter/ui/medical-history/prescription.dart';
import 'package:vesalius_m_flutter/ui/medical-history/referral_letter.dart';

import 'bill_summary.dart';

class MedicalHistoryGroup extends StatefulWidget {
  
  static const String routeName = '/MedicalHistoryGroup';

  final String title;
  final int pageId;

  const MedicalHistoryGroup({
    Key? key, 
    required this.title,
    required this.pageId,
  }) : super(key: key);

  @override
  State<MedicalHistoryGroup> createState() => _MedicalHistoryGroupState();
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
      UserBranch? branchDetails = DataManager.branchDetails;
      List<PatientVisit> lx = await getVesaliusPatientVisit(branchDetails!.branch!.branchId!, branchDetails.prn!, widget.pageId);
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
      DateTime dt1 = DateTime.parse(a.novaVisit!.registrationDate!);
      DateTime dt2 = DateTime.parse(b.novaVisit!.registrationDate!);
      return dt2.compareTo(dt1);
    });
    setState(() {
      list = lx;
      isLoading = false;
    });
  }

  String getDate(PatientVisit o) {
    DateTime dt = DateTime.parse(o.novaVisit!.registrationDate!);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  void onItemTap(PatientVisit o) {
    if (widget.pageId == 4) {
      Get.to(() => BillSummary(
        patientVisit: o,
      ));
    }

    else if (widget.pageId == 3) {
      Get.to(() => Investigation(
        patientVisit: o,
      ));
    }

    else if (widget.pageId == 2) {
      Get.to(() => Prescription(
        patientVisit: o,
      ));
    }

    else if (widget.pageId == 6) {
      Get.to(() => ReferralLetter(
        patientVisit: o,
      ));
    }

    else if (widget.pageId == 7) {
      Get.to(() => HealthScreenRpt(
        patientVisit: o,
      ));
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
          type: o.novaVisit!.visitType!,
          onTap: () {
            onItemTap(o);
          },
        );
      }, 
      separatorBuilder: (context, i) => const Divider(
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
            padding: const EdgeInsets.all(15.0),
            child: Text(
              s,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF727272),
                fontSize: 16.0,
                fontFamily: kBodyFont,
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
      margin: const EdgeInsets.only(top: 40.0),
      width: double.infinity,
      decoration: const BoxDecoration(
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
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Container(
            width: 80.0,
            height: 60.0,
            decoration: const BoxDecoration(
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
            padding: const EdgeInsets.only(right: 20.0, top: 25.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: kTitleFont,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLayer2() {
    EdgeInsets padding = MediaQuery.of(context).padding;

    return SizedBox(
      height: MediaQuery.of(context).size.height - padding.top - kAppToolbarHeight - padding.bottom,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        toolbarHeight: kAppToolbarHeight,
        backgroundColor: kMedicalRecordBgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        leading: const BackBtn(color: Colors.white),
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
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

  const MedicalHistoryGroupItem({
    Key? key, 
    required this.date,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 10.0, top: 25.0, bottom: 25.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                  color: Color(0xFF727272),
                ),
              ),
            ),
            Expanded(
              child: Text(
                type,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontFamily: kBodyFont,
                  color: Color(0xFFBBBBBB),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: kMedicalRecordBgColor,
            ),
          ],
        ),
      ),
    );
  }
}