import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/visit-history/no_record.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'bill_summary.dart';
import 'health_screen_rpt.dart';
import 'investigation.dart';
import 'prescription.dart';
import 'referral_letter.dart';

class VisitHistoryGroup extends StatefulWidget {

  final String title;
  final int pageId;

  const VisitHistoryGroup({
    Key? key, 
    required this.title,
    required this.pageId,
  }) : super(key: key);

  @override
  State<VisitHistoryGroup> createState() => _VisitHistoryGroupState();
}

class _VisitHistoryGroupState extends State<VisitHistoryGroup> {

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

  Widget buildList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return const SizedBox(height: 37.0);
        }

        final o = list[i - 1];
        return VisitHistoryGroupItem(
          patientVisit: o,
          pageId: widget.pageId,
        );
      },
    );
  }

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    if (list.isEmpty) {
      if (widget.pageId == 2) {
        return const NoRecord(msg: 'You do not have any past information at the moment.');
      }

      return const NoRecord();
    }

    return Scrollbar(child: buildList());
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
          widget.title,
          style: kTitleTextStyle,
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kMainColor,
          child: SafeArea(
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}

class VisitHistoryGroupItem extends StatelessWidget {

  final PatientVisit patientVisit;
  final int pageId;

  const VisitHistoryGroupItem({
    Key? key, 
    required this.patientVisit,
    required this.pageId,
  }) : super(key: key);

  String getDate() {
    DateTime dt = DateTime.parse(patientVisit.novaVisit!.registrationDate!);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(229, 229, 229, 0.7),
              blurRadius: 7.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              if (pageId == 4) {
                Get.to(() => BillSummary(
                  patientVisit: patientVisit,
                ));
              }
        
              else if (pageId == 3) {
                Get.to(() => Investigation(
                  patientVisit: patientVisit,
                ));
              }
        
              else if (pageId == 2) {
                Get.to(() => Prescription(
                  patientVisit: patientVisit,
                ));
              }
        
              else if (pageId == 6) {
                Get.to(() => ReferralLetter(
                  patientVisit: patientVisit,
                ));
              }
        
              else if (pageId == 7) {
                Get.to(() => HealthScreenRpt(
                  patientVisit: patientVisit,
                ));
              }
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 12.0, bottom: 12.0),
              child: Row(
                children: [
                  Image.asset(
                    patientVisit.novaVisit?.visitType == 'OUTPATIENT' ? 'images/icon/outpatient.png' : 'images/icon/inpatient.png',
                    width: 48.0,
                    height: 48.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDate(),
                          style: kMainTextStyle.copyWith(
                            fontFamily: kBodyFont,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          patientVisit.novaVisit?.visitType ?? '',
                          style: kTitleTextStyle.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}