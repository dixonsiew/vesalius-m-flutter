import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/new_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/appointment/select_patient_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';
import 'package:vesalius_m_flutter/ui/appointment/new_appointment.dart';

import 'new_appointment_2.dart';

class SelectPatient extends StatefulWidget {

  final DoctorInfo doctorInfo;
  final bool isEdit;
  final List<Family> list;

  const SelectPatient({
    super.key,
    required this.doctorInfo,
    this.isEdit = false,
    this.list = const[],
  });

  @override
  State<SelectPatient> createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final SelectPatientCtrl ctrl = Get.put(SelectPatientCtrl());
  final NewAppointmentCtrl newAppointmentCtrl = Get.put(NewAppointmentCtrl());

  final List<PatientRef> list = [
    PatientRef(id: 0, first: 'E', name: 'Abu bin Ahmad', type: 'Self'),
    PatientRef(id: 1, first: 'R', name: 'Raja Abu bin Ahmad', type: 'Father'),
    PatientRef(id: 2, first: 'N', name: 'Nadia binti Mohammad', type: 'Spouse'),
    PatientRef(id: 3, first: 'A', name: 'Alia binti Abu', type: 'Daughter'),
  ];

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(scrollListener);
    if (widget.list.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => load());
    }

    else {
      ctrl.setSelectPatient(true);
      ctrl.setList(widget.list);
    }
  }

  @override
  void dispose() {
    scr.removeListener(scrollListener);
    scr.dispose();
    super.dispose();
  }

  void scrollListener() {
    final nextPageTrigger = 0.8 * scr.position.maxScrollExtent;
    if (scr.position.pixels > nextPageTrigger) {
      loadMore();
    }
  }

  void load() async {
    try {
      ctrl.init();
      ctrl.setIsLoading(true);
      List<Family> lx = await MyFamilyService.getAllFamilies(ctrl.page, kPageSize, true, true);
      // if (lx.length < 2) {
      //   ctrl.setFamily(null);
      //   Get.off(() => NewAppointment(doctorInfo: widget.doctorInfo));
      // }

      ctrl.setSelectPatient(true);
      ctrl.setList(lx);
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

  void loadMore() async {
    int p = ctrl.page + 1;
    try {
      if (ctrl.isLoadingMore) return;
      ctrl.setIsLoadingMore(true);
      List<Family> lx = await MyFamilyService.getAllFamilies(p, kPageSize, false, true);
      if (lx.isEmpty) {
        ctrl.setIsLoadingMore(false);
        return;
      }

      ctrl.setPage(p);
      ctrl.setList(lx);
      ctrl.setIsLoadingMore(false);
    }
    
    on DioException catch (error) {
      ctrl.setIsLoadingMore(false);
      handleLoadError(error, loadMore);
    }

    catch (error) {
      ctrl.setIsLoadingMore(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  void onNext() {
    ctrl.setFamily(ctrl.xfamily);
    if (widget.isEdit) {
      Get.back();
    }

    else {
      if (ctrl.isFromPackage) {
        newAppointmentCtrl.setXCaseType('New Case');
        newAppointmentCtrl.setCaseType(newAppointmentCtrl.xcaseType);
        Get.to(() => NewAppointment2(doctorInfo: widget.doctorInfo));
      }

      else {
        Get.to(() => NewAppointment(doctorInfo: widget.doctorInfo));
      }
    }
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Scrollbar(
            controller: scr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildList(),
              
              /* ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 24.0),
                  Text(
                    'Who is this appointment for?',
                    style: kTextStyle1.copyWith(
                      fontFamily: kFont2,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  for (int i = 0; i < list.length; i++) ...[
                    PatientItem(name: list[i].name, type: list[i].type, first: list[i].first),
                  ],
                ],
              ), */
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Next',
                    onPressed: ctrl.xfamily == null ? null : onNext,
                  ),
                ),
                const SizedBox(height: 16.0),
                AppOutlinedButton(
                  text: 'Cancel',
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget buildList() {
    return Obx(() =>
      ListView.builder(
        controller: scr,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: ctrl.list.length + 4,
        itemBuilder: (context, i) {
          if (i == 0) {
            return const SizedBox(height: 24.0);
          }
    
          else if (i == 1) {
            return Text(
              'Who is this appointment for?',
              style: kTextStyle1.copyWith(
                fontFamily: kFont2,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            );
          }
    
          else if (i == 2) {
            return const SizedBox(height: 24.0);
          }
    
          else if (i == ctrl.list.length + 3) {
            return Obx(() => ctrl.isLoadingMore ? const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
                child: AppLoadMoreIndicator(),
            ) : Container());
          }
    
          final o = ctrl.list[i - 3];
          return PatientItem(key: ValueKey(o.aufId), data: o);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Patient',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class PatientItem extends StatelessWidget {

  final Family data;

  final SelectPatientCtrl ctrl = Get.put(SelectPatientCtrl());

  PatientItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: ctrl.xfamily?.prn == data.prn ? kTextColor1 : kColor1.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: kColor1.withValues(alpha: 0.3),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              ctrl.setXFamily(data);
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor2,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        data.fullname.isEmpty ? '' : data.fullname[0].toUpperCase(),
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.fullname,
                          style: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          data.relationship ?? '',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor2,
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