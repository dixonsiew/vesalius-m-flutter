import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/no_record.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/medical-history/medical_history_group_ctrl.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/bill_summary/bill_summary.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/health-screen-rpt/health_screen_rpt.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/investigation/investigation.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/prescription/prescription.dart';
import 'package:vesalius_m_flutter/ui/services/medical-history/referral-letter/referral_letter.dart';

class MedicalHistoryGroup extends StatefulWidget {

  static const String routeName = '/MedicalHistoryGroup';

  final String title;
  final int pageId;

  const MedicalHistoryGroup({
    super.key,
    required this.title,
    required this.pageId,
  });

  @override
  State<MedicalHistoryGroup> createState() => _MedicalHistoryGroupState();
}

class _MedicalHistoryGroupState extends State<MedicalHistoryGroup> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final MedicalHistoryGroupCtrl ctrl = Get.put(MedicalHistoryGroupCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.load();
      var branchDetails = DataManager.branchDetails;
      var lx = await VesaliusService.getVesaliusPatientVisit(branchDetails!.branch!.branchId!, branchDetails.prn!, widget.pageId);
      await sortList(lx);
      await DataManager.setItem('patientVisit-3', ctrl.list);
    }

    catch (error) {
      ctrl.setIsLoading(false);
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
    ctrl.init();
    ctrl.setList(lx);
    ctrl.setIsLoading(false);
  }

  void onItemTap(PatientVisit patientVisit) {
    if (widget.pageId == 2) {
      Get.to(() => Prescription(patientVisit: patientVisit));
    }

    else if (widget.pageId == 3) {
      Get.to(() => Investigation(
        patientVisit: patientVisit,
        date: getDate(patientVisit),
      ));
    }

    else if (widget.pageId == 4) {
      Get.to(() => BillSummary(patientVisit: patientVisit));
    }

    else if (widget.pageId == 6) {
      Get.to(() => ReferralLetter(patientVisit: patientVisit));
    }

    else if (widget.pageId == 7) {
      Get.to(() => HealthScreenRpt(patientVisit: patientVisit));
    }
  }

  String getDate(PatientVisit o) {
    DateTime dt = DateTime.parse(o.novaVisit!.registrationDate!);
    return formatDate(dt.toLocal(), [dd, ' ', M, ' ', yyyy]);
  }

  Widget buildList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ctrl.list.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(height: 18.0);
        }

        final PatientVisit patientVisit = ctrl.list[index - 1];
        return MedicalHistoryGroupItem(
          date: getDate(patientVisit),
          visitType: patientVisit.novaVisit?.visitType ?? '',
          onTap: () {
            onItemTap(patientVisit);
          },
        );
      },
    );
  }

  Widget _buildContent() {
    return Scrollbar(
      child: buildList(),
    );
  }

  Widget buildContent() {
    if (ctrl.isLoading) {
      return Container();
    }

    if (ctrl.list.isEmpty) {
      if (widget.pageId == 2) {
        return const NoRecord(msg: 'You do not have any past information at the moment.');
      }

      return const NoRecord();
    }

    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      color: kPrimaryColor,
      child: _buildContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: widget.title,
      body: SafeArea(
        child: Obx(() => 
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            progressIndicator: const AppActivityIndicator(),
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}

class MedicalHistoryGroupItem extends StatelessWidget {

  final String date;
  final String visitType;
  final void Function() onTap;

  const MedicalHistoryGroupItem({
    super.key,
    required this.date,
    required this.visitType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            color: kBgColor2.withOpacity(0.7),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: visitType == 'OUTPATIENT' ? kSecondaryColor : kSecondaryColor2,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      visitType == 'OUTPATIENT' ? 'images/imgs/outpatient.png' : 'images/imgs/inpatient.png',
                      width: 18.0,
                      height: 18.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        visitType,
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
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
    );
  }
}