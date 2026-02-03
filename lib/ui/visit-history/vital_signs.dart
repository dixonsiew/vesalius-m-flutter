import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/bp.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/weight.dart';
import 'package:vesalius_m_flutter/ui/visit-history/vital-signs/bmi.dart';
import 'package:vesalius_m_flutter/ui/visit-history/vital-signs/height.dart';
import 'package:vesalius_m_flutter/ui/visit-history/vital-signs/pr.dart';

class VitalSigns extends StatefulWidget {
  
  static const String routeName = '/VitalSigns';

  const VitalSigns({Key? key}) : super(key: key);

  @override
  State<VitalSigns> createState() => _VitalSignsState();
}

class _VitalSignsState extends State<VitalSigns> {

  List<PatientVisit> list = [];
  PatientVisit? patientVisit;
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
      List<PatientVisit> lx = await getVesaliusPatientVisit(branchDetails!.branch!.branchId!, branchDetails.prn!, 5);
      setState(() {
        list = lx;
        patientVisit = lx.isNotEmpty ? lx.first : null;
        isLoading = false;
      });
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

  Widget buildContent() {
    if (isLoading) {
      return Container();
    }

    if (patientVisit == null) {
      return Container();
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicalInfo(patientVisit: patientVisit!),
            const SizedBox(height: 16.0),
            VitalSignsItem(title: 'Blood Pressure', code: 'BP', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'BP', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'BMI', code: 'BMI', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'BMI', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'Pulse Rate', code: 'PR', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'PR', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'Weight', code: 'WT', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'WT', orElse: () => NovaVisitVitalSignsDetail())),
            VitalSignsItem(title: 'Height', code: 'HT', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'HT', orElse: () => NovaVisitVitalSignsDetail())),
          ],
        ),
      ),
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
          'Vital Signs',
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

class VitalSignsItem extends StatelessWidget {

  final String? title;
  final String? code;
  final NovaVisitVitalSignsDetail? data;
  final PatientVisit? patientVisit;

  const VitalSignsItem({
    Key? key, 
    this.title,
    this.code,
    this.data,
    this.patientVisit,
  }) : super(key: key);

  String get registrationDate {
    DateTime dt = DateTime.parse(patientVisit!.novaVisit!.registrationDate!);
    return formatDate(dt.toLocal(), [yyyy, '-', m, '-', dd]);
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

  void onChart(BuildContext context) {
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
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: kMainTextStyle.copyWith(
                    fontSize: 12.0,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  value,
                  style: kBodyTextStyle.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          data?.value1 == null || data?.value1 == '' ? Container() : IconButton(
            onPressed:() => onChart(context),
            icon: Image.asset(
              'images/icon/chart1.png',
              width: 48.0,
              height: 48.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}