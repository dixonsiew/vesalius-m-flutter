import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/medical-history/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/medical-history/vital_signs_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

import 'vital-signs/bmi.dart';
import 'vital-signs/bp.dart';
import 'vital-signs/height.dart';
import 'vital-signs/pr.dart';
import 'vital-signs/weight.dart';

class VitalSigns extends StatefulWidget {

  const VitalSigns({super.key});

  @override
  State<VitalSigns> createState() => _VitalSignsState();
}

class _VitalSignsState extends State<VitalSigns> {

  ScrollController scr = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final VitalSignsCtrl ctrl = Get.put(VitalSignsCtrl());

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
      await AuthManager.instance.load();
      UserBranch? branchDetails = DataManager.instance.branchDetails;
      List<PatientVisit> lx = await VesaliusService.getVesaliusPatientVisit(branchDetails!.branch!.branchId!, branchDetails.prn!, 5);
      ctrl.init();
      ctrl.setList(lx);
      ctrl.setPatientVisit(lx.isNotEmpty ? lx.first : null);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleLoadError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  Widget buildContent() {
    if (ctrl.isLoading || ctrl.patientVisit == null) {
      return Container();
    }

    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      color: kPrimaryColor,
      child: Scrollbar(
        controller: scr,
        child: ListView(
          controller: scr,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            MedicalInfo(patientVisit: ctrl.patientVisit!),
            const SizedBox(height: 24.0),
            VitalSignsItem(title: 'Blood Pressure', code: 'BP', patientVisit: ctrl.patientVisit!, data: ctrl.patientVisit!.novaVisitVitalSignsDetailList.firstWhere((k) => k.code == 'BP', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'BMI', code: 'BMI', patientVisit: ctrl.patientVisit!, data: ctrl.patientVisit!.novaVisitVitalSignsDetailList.firstWhere((k) => k.code == 'BMI', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'Pulse Rate', code: 'PR', patientVisit: ctrl.patientVisit!, data: ctrl.patientVisit!.novaVisitVitalSignsDetailList.firstWhere((k) => k.code == 'PR', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'Weight', code: 'WT', patientVisit: ctrl.patientVisit!, data: ctrl.patientVisit!.novaVisitVitalSignsDetailList.firstWhere((k) => k.code == 'WT', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'Height', code: 'HT', patientVisit: ctrl.patientVisit!, data: ctrl.patientVisit!.novaVisitVitalSignsDetailList.firstWhere((k) => k.code == 'HT', orElse: () => NovaVisitVitalSignsDetail())),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Vital Signs',
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

class VitalSignsItem extends StatelessWidget {

  final String? title;
  final String? code;
  final NovaVisitVitalSignsDetail? data;
  final PatientVisit? patientVisit;

  const VitalSignsItem({
    super.key,
    this.title,
    this.code,
    this.data,
    this.patientVisit,
  });

  String get registrationDate {
    String s = patientVisit?.novaVisit?.registrationDate ?? '';
    DateTime? dt = DateTime.tryParse(s);
    if (dt != null) {
      s = formatDate(dt.toLocal(), [yyyy, '-', m, '-', dd]);
    }
    
    return s;
  }

  String get bpValue {
    String s = '-';
    if (data?.unit == null || data?.unit == '') {
      return s;
    }

    s = '${data?.value1}/${data?.value2} mmHg';
    return s;
  }

  String get bmiValue {
    String s = '-';
    if (data?.value1 == null || data?.value1 == '') {
      return s;
    }

    s = '${data?.value1} kg/m\u00B2';
    return s;
  }

  String get prValue {
    String s = '-';
    if (data?.value1 == null || data?.value1 == '') {
      return s;
    }

    String unit = '';
    if (code == 'PR') {
      unit = 'bpm';
    } else if (code == 'WT') {
      unit = 'kg';
    } else if (code == 'HT') {
      unit = 'cm';
    }

    s = '${data?.value1} $unit';
    return s;
  }

  String get value {
    String s = '';
    if (code == 'BP') {
      s = bpValue;
    } else if (code =='BMI') {
      s = bmiValue;
    } else if (code == 'PR') {
      s = prValue;
    } else if (code == 'WT') {
      s = prValue;
    } else if (code == 'HT') {
      s = prValue;
    }
    return s;
  }

  void onChart() {
    if (code == 'BP') {
      Get.to(() => BP(
        date: registrationDate,
      ));
    }

    else if (code == 'BMI') {
      Get.to(() => BMI(
        date: registrationDate,
      ));
    }

    else if (code == 'PR') {
      Get.to(() => PR(
        date: registrationDate,
      ));
    }

    else if (code == 'WT') {
      Get.to(() => Weight(
        date: registrationDate,
      ));
    }

    else if (code == 'HT') {
      Get.to(() => Height(
        date: registrationDate,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withValues(alpha: 0.7),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 17.0, bottom: 17.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor2,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      value,
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: kTextColor1,
                      ),
                    ),
                  ],
                ),
              ),
              data?.value1 == null || data?.value1 == '' ? Container() : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: onChart,
                  splashRadius: 32.0,
                  icon: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'images/icon/chart.png',
                        width: 16.0,
                        height: 16.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}