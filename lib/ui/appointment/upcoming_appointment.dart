import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/appointment/upcoming_appointment_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class UpcomingAppointment extends StatefulWidget {

  const UpcomingAppointment({super.key});

  @override
  State<UpcomingAppointment> createState() => _UpcomingAppointmentState();
}

class _UpcomingAppointmentState extends State<UpcomingAppointment> with AutomaticKeepAliveClientMixin<UpcomingAppointment> {

  late final TextEditingController txtreason;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final UpcomingAppointmentCtrl ctrl = Get.put(UpcomingAppointmentCtrl());
  final HomeCtrl homeCtrl = Get.put(HomeCtrl());

  @override
  void initState() {
    super.initState();
    txtreason = TextEditingController();
    load();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      
    // });
  }

  @override
  void dispose() {
    txtreason.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.load();
      await ctrl.load();
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
    }
  }

  void onSubmitCancel(String s, PatientAppointment o) async {
    try {
      if (s.isEmpty) {
        return;
      }

      ctrl.setIsLoading(true);
      final branchDetails = DataManager.branchDetails!;
      final m = {
        'appointmentNumber': o.apptNo,
        'reason': s,
      };
      await VesaliusService.postVesaliusCancelAppointment(branchDetails.branch!.branchId!, branchDetails.prn!, m);
      //await ctrl.load();
      ctrl.remove(o.apptNo);
      if (ctrl.list.isEmpty) {
        homeCtrl.setAppointment(null);
      }

      else {
        homeCtrl.setAppointment(ctrl.list.first);
      }

      ctrl.setIsLoading(false);
      showDone();
    }

    catch (_) {
      ctrl.setIsLoading(false);
      showCustomDialog('Failed', 'Unable to cancel appointment at the moment. Please check your internet connection or try again later.', 'Dismiss');
    }
  }

  void showDone() {
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
              'Appointment Cancel Successfully',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Your appointment has been cancelled.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  Future<String> showCancel() async {
    return await Get.dialog(AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Are you sure want to cancel this appointment?',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kTextColor1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 17.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withOpacity(0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: TextField(
                controller: txtreason,
                cursorColor: kTextColor1,
                style: const TextStyle(
                  fontFamily: kBodyFont,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor1,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Share your reason with us',
                  hintStyle: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB1B1B1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withOpacity(0.7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withOpacity(0.7)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    text: 'Cancel',
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 18.0),
                Expanded(
                  child: AppElevatedButton(
                    text: 'Sure',
                    onPressed: () => Get.back(result: txtreason.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )) ?? '';
  }

  Future<void> onRefresh() async {
    load();
  }

  // Widget buildList() {
  //   return ListView.separated(
  //     shrinkWrap: true,
  //     itemCount: list.length + 2,
  //     itemBuilder: (context, i) {
  //       if (i == 0) {
  //         return const SizedBox(height: 30.0);
  //       }

  //       else if (i == list.length + 1) {
  //         return const Spacer();
  //       }
        
  //       final o = list[i - 1];
  //       return Container(
  //         margin: const EdgeInsets.only(left: 25.0, right: 25.0),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(5.0),
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Color.fromRGBO(219, 219, 219, 0.6),
  //               blurRadius: 8.0,
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Row(
  //                 children: [
  //                   Image.asset(
  //                     'images/icon/clock2.png',
  //                     width: 14.0,
  //                     height: 14.0,
  //                     fit: BoxFit.cover,
  //                   ),
  //                   const SizedBox(width: 8.0),
  //                   Expanded(
  //                     child: Text(
  //                       '${getDate(o.date!)}, ${getTime(o.startTime!)}',
  //                       style: kTextStyle1.copyWith(
  //                         fontWeight: FontWeight.w700,
  //                         color: kPrimaryColor,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const Divider(
  //               thickness: 1.0,
  //               color: Color.fromRGBO(218, 218, 218, 0.45),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 16.0, top: 15.0, bottom: 16.0),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     width: 64.0,
  //                     height: 64.0,
  //                     decoration: const BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       image: DecorationImage(
  //                         image: AssetImage('images/imgs/pic.png'),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10.0),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           o.doctorName!,
  //                           style: kTextStyle1.copyWith(
  //                             fontFamily: kBodyFont,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8.0),
  //                         Text(
  //                           o.specialty!,
  //                           style: kTextStyle1.copyWith(
  //                             fontFamily: kBodyFont,
  //                             fontSize: 12.0,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8.0),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Image.asset(
  //                               'images/icon/location2.png',
  //                               width: 10.0,
  //                               height: 10.0,
  //                               fit: BoxFit.cover,
  //                             ),
  //                             const SizedBox(width: 8.0),
  //                             Text(
  //                               'Room 212, Level 2',
  //                               style: kTextStyle1.copyWith(
  //                                 fontFamily: kBodyFont,
  //                                 fontSize: 12.0,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     separatorBuilder: (context, i) => const SizedBox(
  //       height: 16.0,
  //     ),
  //   );
  // }

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return const NoAppointment();
    }
    
    return Scrollbar(
      child: Obx(() =>
        ListView.builder(
          shrinkWrap: true,
          itemCount: ctrl.list.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return const SizedBox(height: 32.0);
            }
      
            return AppointmentItem(
              data: ctrl.list[i - 1],
              onCancel: (PatientAppointment o) async {
                String s = await showCancel();
                onSubmitCancel(s, o);
              },
              onReschedule: (PatientAppointment o) {
                
              },
            );
          },
          // children: [
          //   Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5.0),
          //       border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
          //       boxShadow: [
          //         BoxShadow(
          //           color: kBgColor2.withOpacity(0.4),
          //           blurRadius: 7.0,
          //         ),
          //       ],
          //     ),
          //     child: Material(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(5.0),
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               children: [
          //                 Container(
          //                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          //                   decoration: BoxDecoration(
          //                     color: const Color(0xFFE1EDFF),
          //                     borderRadius: BorderRadius.circular(2.0),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Image.asset(
          //                         'images/icon/clock5.png',
          //                         width: 10.0,
          //                         height: 10.0,
          //                         fit: BoxFit.cover,
          //                       ),
          //                       const SizedBox(width: 4.0),
          //                       Text(
          //                         '12 Dec, 3:30 PM',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 10.0,
          //                           fontWeight: FontWeight.w500,
          //                           color: kTextColor1,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 const SizedBox(width: 8.0),
          //                 Container(
          //                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          //                   decoration: BoxDecoration(
          //                     color: const Color(0xFFE1EDFF),
          //                     borderRadius: BorderRadius.circular(2.0),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Image.asset(
          //                         'images/icon/user.png',
          //                         width: 10.0,
          //                         height: 10.0,
          //                         fit: BoxFit.cover,
          //                       ),
          //                       const SizedBox(width: 4.0),
          //                       Text(
          //                         'Raja Abu bin Ahmad',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 10.0,
          //                           fontWeight: FontWeight.w500,
          //                           color: kTextColor1,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 8.0),
          //             Row(
          //               children: [
          //                 Image.asset(
          //                   'images/imgs/doctor.png',
          //                   width: 64.0,
          //                   height: 64.0,
          //                   fit: BoxFit.cover,
          //                 ),
          //                 const SizedBox(width: 10.0),
          //                 Expanded(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         "Tan Sri Dato' Dr Zain",
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w600,
          //                           color: kTextColor4,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 8.0),
          //                       Row(
          //                         children: [
          //                           Expanded(
          //                             child: Text(
          //                               'Consultant Cardiothoracic Surgeon',
          //                               style: kTextStyle1.copyWith(
          //                                 fontSize: 10.0,
          //                                 fontWeight: FontWeight.w400,
          //                                 color: kTextColor4,
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       const SizedBox(height: 8.0),
          //                       Row(
          //                         children: [
          //                           Image.asset(
          //                             'images/icon/location1.png',
          //                             width: 10.0,
          //                             height: 10.0,
          //                             fit: BoxFit.cover,
          //                           ),
          //                           const SizedBox(width: 6.0),
          //                           Text(
          //                             'Room 212, Level 2',
          //                             style: kTextStyle1.copyWith(
          //                               fontSize: 10.0,
          //                               fontWeight: FontWeight.w400,
          //                               color: kTextColor4,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 4.0),
          //                   child: IconButton(
          //                     onPressed: () {
                                
          //                     },
          //                     splashRadius: 22.0,
          //                     icon: Container(
          //                       width: 22.0,
          //                       height: 22.0,
          //                       decoration: const BoxDecoration(
          //                         color: kSecondaryColor,
          //                         shape: BoxShape.circle,
          //                       ),
          //                       child: const Center(
          //                         child: Icon(
          //                           Icons.call,
          //                           color: kPrimaryColor,
          //                           size: 12.0,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 10.0),
          //             Padding(
          //               padding: const EdgeInsets.only(right: 16.0),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Expanded(
          //                     child: AppOutlinedButtonSm(
          //                       onPressed: () async {
          //                         String s = await showCancel();
          //                         onSubmitCancel(s);
          //                       },
          //                       text: 'Cancel',
          //                     ),
          //                   ),
          //                   const SizedBox(width: 11.0),
          //                   Expanded(
          //                     child: ElevatedButton(
          //                       onPressed: () {
                                  
          //                       },
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor: kPrimaryColor,
          //                         foregroundColor: Colors.white,
          //                         minimumSize: const Size(double.infinity, 32.0),
          //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          //                       ),
          //                       child: Text(
          //                         'Reschedule',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          //   const SizedBox(height: 16.0),
          //   Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5.0),
          //       border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
          //       boxShadow: [
          //         BoxShadow(
          //           color: kBgColor2.withOpacity(0.4),
          //           blurRadius: 7.0,
          //         ),
          //       ],
          //     ),
          //     child: Material(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(5.0),
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               children: [
          //                 Container(
          //                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          //                   decoration: BoxDecoration(
          //                     color: const Color(0xFFE1EDFF),
          //                     borderRadius: BorderRadius.circular(2.0),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Image.asset(
          //                         'images/icon/clock5.png',
          //                         width: 10.0,
          //                         height: 10.0,
          //                         fit: BoxFit.cover,
          //                       ),
          //                       const SizedBox(width: 4.0),
          //                       Text(
          //                         '12 Dec, 3:30 PM',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 10.0,
          //                           fontWeight: FontWeight.w500,
          //                           color: kTextColor1,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 const SizedBox(width: 8.0),
          //                 Container(
          //                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          //                   decoration: BoxDecoration(
          //                     color: const Color(0xFFE1EDFF),
          //                     borderRadius: BorderRadius.circular(2.0),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       Image.asset(
          //                         'images/icon/user.png',
          //                         width: 10.0,
          //                         height: 10.0,
          //                         fit: BoxFit.cover,
          //                       ),
          //                       const SizedBox(width: 4.0),
          //                       Text(
          //                         'Raja Abu bin Ahmad',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 10.0,
          //                           fontWeight: FontWeight.w500,
          //                           color: kTextColor1,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 8.0),
          //             Row(
          //               children: [
          //                 Image.asset(
          //                   'images/imgs/doctor.png',
          //                   width: 64.0,
          //                   height: 64.0,
          //                   fit: BoxFit.cover,
          //                 ),
          //                 const SizedBox(width: 10.0),
          //                 Expanded(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         "Tan Sri Dato' Dr Zain",
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w600,
          //                           color: kTextColor4,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 8.0),
          //                       Row(
          //                         children: [
          //                           Expanded(
          //                             child: Text(
          //                               'Consultant Cardiothoracic Surgeon',
          //                               style: kTextStyle1.copyWith(
          //                                 fontSize: 10.0,
          //                                 fontWeight: FontWeight.w400,
          //                                 color: kTextColor4,
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       const SizedBox(height: 8.0),
          //                       Row(
          //                         children: [
          //                           Image.asset(
          //                             'images/icon/location1.png',
          //                             width: 10.0,
          //                             height: 10.0,
          //                             fit: BoxFit.cover,
          //                           ),
          //                           const SizedBox(width: 6.0),
          //                           Text(
          //                             'Room 212, Level 2',
          //                             style: kTextStyle1.copyWith(
          //                               fontSize: 10.0,
          //                               fontWeight: FontWeight.w400,
          //                               color: kTextColor4,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.only(right: 4.0),
          //                   child: IconButton(
          //                     onPressed: () {
                                
          //                     },
          //                     splashRadius: 22.0,
          //                     icon: Container(
          //                       width: 22.0,
          //                       height: 22.0,
          //                       decoration: const BoxDecoration(
          //                         color: kSecondaryColor,
          //                         shape: BoxShape.circle,
          //                       ),
          //                       child: const Center(
          //                         child: Icon(
          //                           Icons.call,
          //                           color: kPrimaryColor,
          //                           size: 12.0,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: 10.0),
          //             Padding(
          //               padding: const EdgeInsets.only(right: 16.0),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Expanded(
          //                     child: OutlinedButton(
          //                       onPressed: () async {
          //                         String s = await showCancel();
          //                         onSubmitCancel(s);
          //                       },
          //                       style: OutlinedButton.styleFrom(
          //                         foregroundColor: kTextColor2,
          //                         backgroundColor: Colors.white,
          //                         minimumSize: const Size(double.infinity, 32.0),
          //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          //                         side: const BorderSide(
          //                           color: Color(0xFFDBDBDB),
          //                         ),
          //                       ),
          //                       child: Text(
          //                         'Cancel',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   const SizedBox(width: 11.0),
          //                   Expanded(
          //                     child: ElevatedButton(
          //                       onPressed: () {
                                  
          //                       },
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor: kPrimaryColor,
          //                         foregroundColor: Colors.white,
          //                         minimumSize: const Size(double.infinity, 32.0),
          //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          //                       ),
          //                       child: Text(
          //                         'Reschedule',
          //                         style: kTextStyle1.copyWith(
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }

  // Widget buildContent0() {
  //   if (isLoading) {
  //     return Container();
  //   }

  //   if (list.isEmpty) {
  //     return const NoAppointment();
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         color: const Color(0xFFF8F8F8),
  //         height: MediaQuery.of(context).size.height - 320,
  //         child: Scrollbar(
  //           child: buildList(),
  //         ),
  //       ),
  //       Container(
  //         height: 80.0,
  //         margin: const EdgeInsets.only(left: 25.0, right: 25.0),
  //         padding: const EdgeInsets.all(10.0),
  //         decoration: BoxDecoration(
  //           color: kSecondaryColor2,
  //           borderRadius: BorderRadius.circular(5.0),
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Color.fromRGBO(229, 229, 229, 0.1),
  //               offset: Offset(0, 4.0),
  //               blurRadius: 4.0,
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Image.asset(
  //               'images/icon/info.png',
  //               width: 16.0,
  //               height: 16.0,
  //               fit: BoxFit.cover,
  //             ),
  //             const SizedBox(width: 9.0),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Need to reschedule / cancel appointment?',
  //                     style: kTextStyle1.copyWith(
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                   Text(
  //                     'Call Customer Service.',
  //                     style: kTextStyle1.copyWith(
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: const Color(0xFF002E50),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        progressIndicator: const AppActivityIndicator(),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: buildContent(),
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class AppointmentItem extends StatelessWidget {

  final PatientAppointment data;
  final void Function(PatientAppointment) onCancel;
  final void Function(PatientAppointment) onReschedule;

  const AppointmentItem({
    super.key,
    required this.data,
    required this.onCancel,
    required this.onReschedule,
  });

  String getTime(String s) {
    final ts = '2023-01-01T$s:00';
    return formatDate(DateTime.parse(ts), [h, ':', nn, ' ', am]).toUpperCase();
  }

  String getDate(String s) {
    String x = s.replaceAll('-', ' ');
    int i = x.lastIndexOf(' ');
    return x.substring(0, i);
  }

  List<Widget> buildDoctorContent() {
    List<DoctorSpecialities>? specialtyList = data.doctorSpecialities;
    List<DoctorClinicLocation>? locationList = data.doctorClinicLocation;

    List<Widget> ls = [
      Text(
        '${data.name}'.trim().capitalize ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor4,
        ),
      ),
      const SizedBox(height: 8.0),
    ];

    for (int i = 0; i < specialtyList.length; i++) {
      Widget w = Text(
        specialtyList[i].specialities ?? '',
        style: kTextStyle1.copyWith(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: kTextColor4,
        ),
      );
      ls.addAll([
        w,
        const SizedBox(height: 8.0),
      ]);
    }

    if (locationList.isNotEmpty) {
      Widget l = Row(
        children: [
          Image.asset(
            'images/icon/location1.png',
            width: 10.0,
            height: 10.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 6.0),
          Text(
            locationList.first.location ?? '',
            style: kTextStyle1.copyWith(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: kTextColor4,
            ),
          ),
        ],
      );
      ls.add(l);
    }

    else {
      ls.removeLast();
    }

    return ls;
  }

  Image getDoctorImage() {
    String? image = data.image;
    Image im = Image.asset('images/imgs/no_image.png', fit: BoxFit.cover);
    if (image != null && image != '') {
      int i = image.indexOf('base64,');
      String data = image;
      if (i < 0) {
        data = image.trim();
      }

      else {
        data = image.substring(i + 7).trim();
      }
      im = Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    }

    return im;
  }

  Widget buildDoctorItem() {
    List<DoctorContact> contactList = data.doctorContact;
    final List<DoctorContact> lc = contactList.where((x) => x.contactType == 'Contact No').toList();
    final contact = lc.isEmpty ? null : lc.first;

    return Row(
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(32.0),
            child: getDoctorImage(),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildDoctorContent(),
          ),
        ),
        if (contact != null) ...[
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: () {
                makePhoneCall(contact);
              },
              splashRadius: 22.0,
              icon: Container(
                width: 22.0,
                height: 22.0,
                decoration: const BoxDecoration(
                  color: kSecondaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.call,
                    color: kPrimaryColor,
                    size: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withOpacity(0.4),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1EDFF),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/clock5.png',
                          width: 10.0,
                          height: 10.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${getDate(data.apptDate)}, ${getTime(data.apptStartTime)}',
                          //'12 Dec, 3:30 PM',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: kTextColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1EDFF),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/user.png',
                          width: 10.0,
                          height: 10.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Raja Abu bin Ahmad',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: kTextColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              buildDoctorItem(),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppOutlinedButtonSm(
                        onPressed: () async {
                          onCancel.call(data);
                        },
                        text: 'Cancel',
                      ),
                    ),
                    const SizedBox(width: 11.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onReschedule.call(data);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 32.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        ),
                        child: Text(
                          'Reschedule',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoAppointment extends StatelessWidget {

  const NoAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/medical-record.png',
            width: 73.61,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'You do not have any upcoming appointment at the moment.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}