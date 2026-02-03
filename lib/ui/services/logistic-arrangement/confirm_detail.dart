import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/confirm_detail_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic-arrangement/request_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/logistic_arrangement_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/logistic_service.dart';
import 'package:vesalius_m_flutter/ui/services/logistic_arrangement.dart';

class ConfirmDetail extends StatelessWidget {

  final ConfirmDetailCtrl ctrl = Get.put(ConfirmDetailCtrl());
  final RequestCtrl requestCtrl = Get.put(RequestCtrl());
  final LogisticArrangementCtrl logisticArrangementCtrl = Get.put(LogisticArrangementCtrl());

  ConfirmDetail({super.key});

  void showSuccess() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/icon/tick.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Request Submitted Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your airport pickup request has been submitted successfully.\nWe will notify you once your request is confirmed.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () {
                Get.back();
                Get.until((route) => Get.currentRoute == LogisticArrangement.routeName);
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onSubmit() async {
    final frm1 = requestCtrl.reqForm!;
    final frm2 = requestCtrl.reqForm2;
    final frm3 = requestCtrl.reqForm3!;
    try {
      UserBranch? branchDetails = await DataManager.instance.getBranchDetails();
      String prn = branchDetails?.prn ?? '';
      String fprn = requestCtrl.selectedPatient?.prn ?? '';
      final o = {
        'requesterPrn': requestCtrl.isSelf ? prn : fprn,
        'requesterName': frm1.name,
        'requesterDob': frm1.dob,
        'requesterDocType': frm1.idType,
        'requesterDocNumber': frm1.idNum,
        'requesterNationality': frm1.nationality,
        'requesterEmail': frm1.email,
        'primaryDoctor': frm1.doc,
        'visitWithCompanion': frm1.visitWithCompanion == 'No' ? 'N' : 'Y',
        'companionName': frm2?.name ?? '',
        'companionDob': frm2?.dob ?? '',
        'companionDocType': frm2?.idType ?? '',
        'companionDocNumber': frm2?.idNum ?? '',
        'relationshipToRequester': frm2?.relationship ?? '',
        'flightAirlineName': frm3.name,
        'flightNumber': frm3.num,
        'flightArrivalDate': frm3.arrDate,
        'flightArrivalTime': frm3.arrTime,
        'requestedPickupDate': frm3.pickDate,
        'requestedPickupTime': frm3.pickTime
      };
      ctrl.setIsLoading(true);
      await LogisticService.postLogisticRequest(o);
      logisticArrangementCtrl.init();
      await logisticArrangementCtrl.load();
      ctrl.setIsLoading(false);
      showSuccess();
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleSubmitError(error, 'Unable to create new request at the moment. Please check your internet connection or try again later.', null);
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Error', 'Unable to create new request at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 144.0),
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(229, 229, 229, 0.5),
                            offset: Offset(0.0, 4.0),
                            blurRadius: 7.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'General Info',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Patient Name',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                          Text(
                            requestCtrl.reqForm!.name,
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Primary Doctor to visit',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                          Text(
                            requestCtrl.reqForm!.doc == '' ? '-' : requestCtrl.reqForm!.doc,
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            height: 1.0,
                            color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16.0),

                          Text(
                            'Companion Info',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Name',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor2,
                            ),
                          ),
                          Text(
                            requestCtrl.reqForm2?.name ?? '-',
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: kTextColor1,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Identification Number',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Relationship to Patient',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm2?.idNum ?? '-',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm2?.relationship ?? '-',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            height: 1.0,
                            color: const Color(0xFFC2E7EA).withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16.0),

                          Text(
                            'Flight Details',
                            style: kTextStyle1.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Airline Name',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Flight Number',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm3!.name,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm3!.num,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Flight Arrival Date',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Flight Arrival Time',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm3!.arrDate,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm3!.arrTime,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Requested Pickup Date',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Requested Pickup Time',
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: kTextColor2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm3!.pickDate,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  requestCtrl.reqForm3!.pickTime,
                                  style: kTextStyle1.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor1,
                                  ),
                                ),
                              ),
                            ],
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppElevatedButton(
                  text: 'Submit',
                  onPressed: onSubmit,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Confirm Details',
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