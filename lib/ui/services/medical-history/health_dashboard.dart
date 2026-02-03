import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/chart_card.dart';
import 'package:vesalius_m_flutter/components/lab/glucose_chart.dart';
import 'package:vesalius_m_flutter/components/lab/hdl_chart.dart';
import 'package:vesalius_m_flutter/components/lab/hemoglobin_chart.dart';
import 'package:vesalius_m_flutter/components/lab/ldl_chart.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/bmi_chart.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/bp_chart.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/height_chart.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/pr_chart.dart';
import 'package:vesalius_m_flutter/components/medical-history/vital-signs/weight_chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/medical-history/health_dashboard_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/vesalius_service.dart';

class HealthDashboard extends StatefulWidget {

  const HealthDashboard({super.key});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> with SingleTickerProviderStateMixin {

  ScrollController scr0 = ScrollController();
  ScrollController scr1 = ScrollController();
  late TabController tabController;
  final CarouselSliderController _controller = CarouselSliderController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey0 = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();

  final HealthDashboardCtrl ctrl = Get.put(HealthDashboardCtrl());

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(tabListener);
    ctrl.setTabIndex(0);
    tabController.index = ctrl.tabIndex;
    load();
  }

  @override
  void dispose() {
    scr0.dispose();
    scr1.dispose();
    tabController.removeListener(tabListener);
    tabController.dispose();
    super.dispose();
  }

  void tabListener() {
    ctrl.setTabIndex(tabController.index);
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      UserBranch? branchDetails = DataManager.instance.branchDetails;

      await loadVitalSignChart(branchDetails);
      await loadLabChart(branchDetails);
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

  Future<void> loadLabChart(UserBranch? branchDetails) async {
    final lx = await VesaliusService.getLabHistories(branchDetails!.branch!.branchId!, branchDetails.prn!);
    final q1 = lx.firstWhereOrNull((k) => k.labCode == 'HDL');
    final q2 = lx.firstWhereOrNull((k) => k.labCode == 'LDL');
    final q3 = lx.firstWhereOrNull((k) => k.labCode == 'Glucose');
    final q4 = lx.firstWhereOrNull((k) => k.labCode == 'Hemoglobin');
    ctrl.setHdlList(q1 == null ? [] : q1.labData);
    ctrl.setLdlList(q2 == null ? [] : q2.labData);
    ctrl.setGluList(q3 == null ? [] : q3.labData);
    ctrl.setHmgList(q4 == null ? [] : q4.labData);
    ctrl.setIsLoading(false);
  }

  Future<void> loadVitalSignChart(UserBranch? branchDetails) async {
    final lx = await VesaliusService.getVitalSignHistories(branchDetails!.branch!.branchId!, branchDetails.prn!);
    final q1 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'BP');
    final q2 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'BMI');
    final q3 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'PULSE RATE');
    final q4 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'HEIGHT');
    final q5 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'WEIGHT');
    ctrl.setBpList(q1 == null ? [] : q1.vitalSignsData);
    ctrl.setBmiList(q2 == null ? [] : q2.vitalSignsData);
    ctrl.setPrList(q3 == null ? [] : q3.vitalSignsData);
    ctrl.setHeightList(q4 == null ? [] : q4.vitalSignsData);
    ctrl.setWeightList(q5 == null ? [] : q5.vitalSignsData);
  }

  Widget buildChart1() {
    final padding = MediaQuery.of(context).padding;
    final w = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(5.0),
      child: Obx(() => 
        ctrl.isLoading ? Container() : RefreshIndicator(
          key: refreshIndicatorKey1,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: ListView(
            controller: scr1,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 35.0),
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: false,
                  height: MediaQuery.of(context).size.height * 0.65 - padding.top - padding.bottom,
                  //aspectRatio: 1.0,
                  viewportFraction: 1.0,
                  initialPage: ctrl.current1,
                  onPageChanged: (index, reason) {
                    ctrl.setCurrent1(index);
                  },
                ),
                items: [
                  ChartCard(
                    child: HDLChart(list: ctrl.hdlList),
                  ),
                  ChartCard(
                    child: LDLChart(list: ctrl.ldlList),
                  ),
                  ChartCard(
                    child: GlucoseChart(list: ctrl.gluList),
                  ),
                  ChartCard(
                    child: HemoglobinChart(list: ctrl.hmgList),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [0, 1, 2, 3].map((i) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _controller.animateToPage(i);
                    },
                    child: Obx(() =>
                      Container(
                        width: 6.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ctrl.current1 == i
                            ? kPrimaryColor
                            : kColor3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
    return w;
  }

  Widget buildChart0() {
    final padding = MediaQuery.of(context).padding;
    final w = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(5.0),
      child: Obx(() =>
        ctrl.isLoading ? Container() : RefreshIndicator(
          key: refreshIndicatorKey0,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: ListView(
            controller: scr0,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 35.0),
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: false,
                  height: MediaQuery.of(context).size.height * 0.65 - padding.top - padding.bottom,
                  //aspectRatio: 1.0,
                  viewportFraction: 1.0,
                  initialPage: ctrl.current0,
                  onPageChanged: (index, reason) {
                    ctrl.setCurrent0(index);
                  },
                ),
                items: [
                  ChartCard(
                    child: BPChart(list: ctrl.bpList),
                  ),
                  ChartCard(
                    child: BMIChart(list: ctrl.bmiList),
                  ),
                  ChartCard(
                    child: PRChart(list: ctrl.prList),
                  ),
                  ChartCard(
                    child: WeightChart(list: ctrl.weightList),
                  ),
                  ChartCard(
                    child: HeightChart(list: ctrl.heightList),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [0, 1, 2, 3, 4].map((i) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _controller.animateToPage(i);
                    },
                    child: Obx(() =>
                      Container(
                        width: 6.0,
                        height: 6.0,
                        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ctrl.current0 == i
                            ? kPrimaryColor
                            : kColor3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: kAppToolbarHeight,
          automaticallyImplyLeading: false,
          leadingWidth: 100.0,
          backgroundColor: kBgColor1,
          leading: const BackBtn(color: kTextColor1),
          centerTitle: true,
          title: Text(
            'Health Dashboard',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
          elevation: 2.0,
          bottom: TabBar(
            indicatorColor: kPrimaryColor,
            controller: tabController,
            onTap: (int i) {
              ctrl.setTabIndex(i);
            },
            tabs: [
              Tab(
                child: Obx(() =>
                  Text(
                    'Vital Signs',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: ctrl.tabIndex == 0 ? kPrimaryColor : kTextColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Tab(
                child: Obx(() =>
                  Text(
                    'Lab',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: ctrl.tabIndex == 1 ? kPrimaryColor : kTextColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: kBgColor1,
        body: SafeArea(
          child: Obx(() =>
            ModalProgressHUD(
              inAsyncCall: ctrl.isLoading,
              blur: kBlur,
              progressIndicator: const AppActivityIndicator(),
              child: TabBarView(
                controller: tabController,
                children: [
                  buildChart0(),
                  buildChart1(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeSeriesSales {
  final int time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}