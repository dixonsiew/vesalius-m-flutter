import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/medical_info.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/bmi.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/bp.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/height.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/pr.dart';
import 'package:vesalius_m_flutter/ui/medical-history/vital-signs/weight.dart';

class VitalSigns extends StatefulWidget {

  static const String routeName = 'VitalSigns';

  const VitalSigns({Key? key}) : super(key: key);

  @override
  State<VitalSigns> createState() => _VitalSignsState();
}

class _VitalSignsState extends State<VitalSigns> {

  List<PatientVisit> list = [];
  PatientVisit? patientVisit;
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
      var lx = await getVesaliusPatientVisit(branchDetails!.branch!.branchId!, branchDetails.prn!, 5);
      setState(() {
        list = lx;
        patientVisit = lx.isNotEmpty ? lx[0] : null;
        isLoading = false;
      });
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildList() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        'You do not have any past vital signs history at the moment.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF727272),
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget buildLayer2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 120.0, bottom: 110.0),
      child: Container(
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
        child: buildList(),
      ),
    );
  }

  Widget buildLayer1() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 160.0,
          color: kMedicalRecordBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'images/icon/page-header-icon/medical-record.png',
                  width: 80.0,
                  height: 60.0,
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  'Vital Signs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: kTitleFont,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildEmptyContent() {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kMedicalRecordBgColor),
        backgroundColor: kMedicalRecordBgColor,
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

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10.0),
        VitalSignsItem(title: 'Blood Pressure', code: 'BP', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'BP', orElse: () => NovaVisitVitalSignsDetail())),
        VitalSignsItem(title: 'BMI', code: 'BMI', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'BMI', orElse: () => NovaVisitVitalSignsDetail())),
        VitalSignsItem(title: 'Pulse Rate', code: 'PR', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'PR', orElse: () => NovaVisitVitalSignsDetail())),
        VitalSignsItem(title: 'Weight', code: 'WT', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'WT', orElse: () => NovaVisitVitalSignsDetail())),
        VitalSignsItem(title: 'Height', code: 'HT', patientVisit: patientVisit!, data: patientVisit!.novaVisitVitalSignsDetailList!.firstWhere((k) => k.code == 'HT', orElse: () => NovaVisitVitalSignsDetail())),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Widget buildHeader() {
    return MedicalInfo(
      patientVisit: patientVisit!,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (list.isEmpty && !isLoading) {
      return buildEmptyContent();
    }

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHeader(),
                  buildContent(),
                ],
              ),
            ),
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

  String getRegistrationDate() {
    DateTime dt = DateTime.parse(patientVisit!.novaVisit!.registrationDate!);
    return formatDate(dt.toLocal(), [yyyy, '-', m, '-', dd]);
  }

  Widget buildPRValue() {
    if (data?.value1 == null || data?.value1 == '') {
      return const Text(
        '-',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    String unit = '';
    if (code == 'PR') {
      unit = 'bpm';
    } else if (code == 'WT') {
      unit = 'kg';
    } else if (code == 'HT') {
      unit = 'cm';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisSize: MainAxisSize.min,
      textBaseline: TextBaseline.ideographic,
      children: [
        Flexible(
          child: Text(
            '${data?.value1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        Flexible(
          child: Text(
            unit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBPValue() {
    if (data?.unit == null || data?.unit == '') {
      return const Text(
        '-',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisSize: MainAxisSize.min,
      textBaseline: TextBaseline.ideographic,
      children: [
        Flexible(
          child: Text(
            '${data?.value1}/${data?.value2}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        const Flexible(
          child: Text(
            'mmHg',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBMIValue() {
    if (data?.value1 == null || data?.value1 == '') {
      return const Text(
        '-',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontFamily: kBodyFont,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      mainAxisSize: MainAxisSize.min,
      textBaseline: TextBaseline.ideographic,
      children: [
        Flexible(
          child: Text(
            '${data?.value1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        const Flexible(
          child: Text(
            'kg/m\u00B2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: kBodyFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPR(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                ),
              ),
              buildPRValue(),
            ],
          ),
        ),
        data?.value1 == null || data?.value1 == '' ? Container() : ElevatedButton(
          onPressed: () {
            if (code == 'PR') {
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => PR(
                    date: getRegistrationDate(),
                  ),
                )
              );
            }

            else if (code == 'WT') {
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => Weight(
                    date: getRegistrationDate(),
                  ),
                )
              );
            }
            
            else if (code == 'HT') {
              Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => Height(
                    date: getRegistrationDate(),
                  ),
                )
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kMedicalRecordBgColor,
            minimumSize: const Size(24.0, 32.0),
          ),
          child: const Icon(
            Icons.analytics,
          ),
        ),
      ],
    );
  }

  Widget buildBMI(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                ),
              ),
              buildBMIValue()
            ],
          ),
        ),
        data?.value1 == null || data?.value1 == '' ? Container() : ElevatedButton(
          onPressed: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => BMI(
                  date: getRegistrationDate(),
                ),
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kMedicalRecordBgColor,
            minimumSize: const Size(24.0, 32.0),
          ),
          child: const Icon(
            Icons.analytics,
          ),
        ),
      ],
    );
  }

  Widget buildBP(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: kBodyFont,
                ),
              ),
              buildBPValue(),
            ],
          ),
        ),
        data?.unit == null || data?.unit == '' ? Container() : ElevatedButton(
          onPressed: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => BP(
                  date: getRegistrationDate(),
                ),
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kMedicalRecordBgColor,
            minimumSize: const Size(24.0, 32.0),
          ),
          child: const Icon(
            Icons.analytics,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? o;

    if (code == 'BP') {
      o = buildBP(context);
    }

    else if (code =='BMI') {
      o = buildBMI(context);
    }

    else if (code == 'PR') {
      o = buildPR(context);
    }

    else if (code == 'WT') {
      o = buildPR(context);
    }

    else if (code == 'HT') {
      o = buildPR(context);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0, bottom: 10.0),
        decoration: const BoxDecoration(
          color: kMedicalRecordBgColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: o,
      ),
    );
  }
}