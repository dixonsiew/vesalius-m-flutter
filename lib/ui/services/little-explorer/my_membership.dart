import 'package:barcode_widget/barcode_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/little-explorer/my_membership_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/hospital_data.dart';
import 'package:vesalius_m_flutter/models/kidsclub_data.dart';
import 'package:vesalius_m_flutter/services/clubs_service.dart';
import 'package:vesalius_m_flutter/services/common_service.dart';

import 'register_exp.dart';

class MyMembership extends StatefulWidget {

  final KidsClub data;

  const MyMembership({
    super.key,
    required this.data,
  });

  @override
  State<MyMembership> createState() => _MyMembershipState();
}

class _MyMembershipState extends State<MyMembership> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final MyMembershipCtrl ctrl = Get.put(MyMembershipCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final hospitalData = await CommonService.getHospitalInfo();
      ctrl.setHospitalData(hospitalData);

      if (AuthManager.instance.isLogin == false) {
        ctrl.setIsLoading(false);
        return;
      }

      List<KidsMembership> lx = await ClubsService.getAllLittleKidsMemberships(1, kPageSize);
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

  Future<void> onRefresh() async {
    load();
  }

  void onSubmit() {
    //Get.to(() => TnC(data: widget.data.kidsClubTnc));
    Get.to(() => const RegisterExp());
  }

  Widget buildContent() {
    return Stack(
      children: [
        if (!ctrl.isLoading && ctrl.list.isEmpty) ...[
          NoMembership(onRefresh: onRefresh),
        ] else ...[
          Padding(
            padding: EdgeInsets.only(bottom: AuthManager.instance.isLogin ? 80.0: 0.0),
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ctrl.list.length,
                  itemBuilder: (context, i) {
                    return MembershipItem(data: ctrl.list[i], hospitalData: ctrl.hospitalData);
                  },
                ),
              ),
            ),
          ),
        ],
        if (AuthManager.instance.isLogin) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppElevatedButton(
                text: 'Register New Member',
                onPressed: onSubmit,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'My Membership',
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

class MembershipItem extends StatelessWidget {

  final KidsMembership data;
  final HospitalInfo? hospitalData;

  const MembershipItem({
    super.key,
    required this.data,
    required this.hospitalData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'images/imgs/ihp.png',
              width: 122.07,
              height: 32.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Name',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Membership No',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  data.kidsName,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.kidsMembershipNumber,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'DOB',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'NRIC',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  data.kidsDobStr,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.kidsDocNumber,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'PRN',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Gender',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  data.kidsPrn ?? data.guardianPrn ?? '',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.kidsGender,
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: data.kidsPrn ?? data.guardianPrn ?? '',
              height: 40.0,
              color: Colors.black,
              drawText: false,
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: kTextColor4,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            hospitalData?.website ?? 'www.islandhospital.com',
            style: kTextStyle1.copyWith(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: kTextColor6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    makePhoneCallNum(hospitalData?.contactInfoApptCall ?? '+6042383388');
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Contact ${hospitalData?.contactInfoApptDisplay ?? '+604 238 3388'}',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor6,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '|',
                style: kTextStyle1.copyWith(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor6,
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    makePhoneCallNum(hospitalData?.contact24Call ?? '+6042268527');
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Emergency Hotline ${hospitalData?.contact24Display ?? '+604 226 8527'}',
                      style: kTextStyle1.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'International Patient Service',
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor6,
                  ),
                ),
              ),
              const SizedBox(width: 4.0),
              Material(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    launchWANum(hospitalData?.contactWhatsAppCall ?? '6042383333');
                  },
                  borderRadius: BorderRadius.circular(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/icon/wa.png',
                          width: 16.0,
                          height: 16.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          hospitalData?.contactWhatsAppDisplay ?? '+604 238 3333',
                          style: kTextStyle1.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoMembership extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoMembership({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/imgs/member1.png',
            width: 96.0,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'No registered member found at the moment.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}