import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/my-family/my_family_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/family_data.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

import 'my-family/family_detail.dart';

class MyFamily extends StatefulWidget {

  const MyFamily({super.key});

  @override
  State<MyFamily> createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final MyFamilyCtrl ctrl = Get.put(MyFamilyCtrl());

  @override
  void initState() {
    super.initState();
    scr = ScrollController();
    scr.addListener(scrollListener);
    load();
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
      await AuthManager.instance.load();
      List<Family> lx = await MyFamilyService.getAllFamilies(ctrl.page, kPageSize);
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
      List<Family> lx = await MyFamilyService.getAllFamilies(p, kPageSize);
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

  Widget buildContent() {
    if (!ctrl.isLoading && ctrl.list.isEmpty) {
      return NoFamily(onRefresh: onRefresh);
    }

    return Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Obx(() => 
          ListView.builder(
            controller: scr,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: ctrl.list.length + 1,
            itemBuilder: (context, i) {
              if (i == ctrl.list.length) {
                return Obx(() => ctrl.isLoadingMore ? const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: AppLoadMoreIndicator(),
                ) : Container());
              }
      
              final o = ctrl.list[i];
              return FamilyItem(
                key: ValueKey(o.aufId),
                data: o,
              );
            }
      
            /* children: [
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Dismissible(
                  key: const Key('0'),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                          offset: const Offset(0.0, 4.0),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      child: InkWell(
                        onTap: () {
                          
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
                                  shape: BoxShape.circle,
                                  color: kSecondaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'R',
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
                                      'Raja Abu bin Ahmad',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor1,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Father',
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
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Dismissible(
                  key: const Key('1'),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                          offset: const Offset(0.0, 4.0),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      child: InkWell(
                        onTap: () {
                          
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
                                  shape: BoxShape.circle,
                                  color: kSecondaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'N',
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
                                      'Nadia binti Mohammad',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor1,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Spouse',
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
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Dismissible(
                  key: const Key('2'),
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                          offset: const Offset(0.0, 4.0),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      child: InkWell(
                        onTap: () {
                          
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
                                  shape: BoxShape.circle,
                                  color: kSecondaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'A',
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
                                      'Alia binti Abu',
                                      style: kTextStyle1.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColor1,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Daughter',
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
                ),
              ),
            ], */
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'My Family Member',
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
      /* actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const AddFamily());
          },
          icon: const Icon(
            Icons.add_circle_rounded,
            color: kPrimaryColor,
          ),
        ),
      ], */
    );
  }
}

class FamilyItem extends StatelessWidget {

  final Family data;

  const FamilyItem({
    super.key,
    required this.data,
  });

  String get patientID {
    String s = data.isPatient == true ? data.prn ?? '-' : data.docNum ?? '-';
    return '$s (${data.relationship})';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
              offset: const Offset(0.0, 4.0),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          child: InkWell(
            onTap: () {
              Get.to(() => FamilyDetail(data: data));
            },
            borderRadius: BorderRadius.circular(5.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
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
                          patientID,
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor2,
                          ),
                        ),
                        if (data.isPatient == false) ...[
                          const SizedBox(height: 8.0),
                          Text(
                            'This patient is not registered in IH',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  if (data.isKidsExplorer || data.isGoldenPearl) ...[
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5394A6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          data.isKidsExplorer ? 'images/imgs/little-explorer.png' : 'images/imgs/golden-pearl.png',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ] else ...[
                    if (data.isPatient == false) ...[
                      Image.asset(
                        'images/imgs/no-prn.png',
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ] else ...[
                      Image.asset(
                        'images/imgs/patient.png',
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoFamily extends StatelessWidget {

  final Future<void> Function() onRefresh;

  const NoFamily({
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
            'images/imgs/family1.png',
            width: 80.0,
            height: 80.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Text(
              'You do not have any family member under your profile at the moment.',
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