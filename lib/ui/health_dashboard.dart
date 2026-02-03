import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/components/chart_card.dart';
import 'package:vesalius_m_flutter/components/lab/glucose_chart.dart';
import 'package:vesalius_m_flutter/components/lab/hdl_chart.dart';
import 'package:vesalius_m_flutter/components/lab/hemoglobin_chart.dart';
import 'package:vesalius_m_flutter/components/lab/ldl_chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/bmi_chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/bp_chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/height_chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/pr_chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/weight_chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data_manager.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/services/data_service.dart';

class HealthDashboard extends StatefulWidget {
  
  static const String routeName = '/HealthDashboard';

  const HealthDashboard({Key? key}) : super(key: key);

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> with SingleTickerProviderStateMixin {

  List<VitalSignsData> bpList = [];
  List<VitalSignsData> bmiList = [];
  List<VitalSignsData> prList = [];
  List<VitalSignsData> heightList = [];
  List<VitalSignsData> weightList = [];

  List<LabData> hdlList = [];
  List<LabData> ldlList = [];
  List<LabData> gluList = [];
  List<LabData> hmgList = [];

  int tabIndex = 0;
  int current0 = 0;
  int current1 = 0;
  bool isLoading = false;
  late TabController tabController;
  final CarouselController _controller = CarouselController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey0 = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
    tabIndex = 0;
    tabController.index = tabIndex;
    super.initState();
    load();
  }

  @override
  void dispose() {
    tabController.dispose();
    tabController.removeListener(() { });
    super.dispose();
  }

  void load() async {
    try {
      setState(() {
        isLoading = true;
      });
      var branchDetails = DataManager.branchDetails;

      await loadVitalSignChart(branchDetails);
      await loadLabChart(branchDetails);
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

  Future<void> loadLabChart(UserBranch? branchDetails) async {
    var lx = await getLabHistories(branchDetails!.branch!.branchId!, branchDetails.prn!);
    var q1 = lx.firstWhereOrNull((k) => k.labCode == 'HDL');
    var q2 = lx.firstWhereOrNull((k) => k.labCode == 'LDL');
    var q3 = lx.firstWhereOrNull((k) => k.labCode == 'Glucose');
    var q4 = lx.firstWhereOrNull((k) => k.labCode == 'Hemoglobin');
    setState(() {
      hdlList = q1 == null ? [] : q1.labData!;
      ldlList = q2 == null ? [] : q2.labData!;
      gluList = q3 == null ? [] : q3.labData!;
      hmgList = q4 == null ? [] : q4.labData!;
      isLoading = false;
    });
  }

  Future<void> loadVitalSignChart(UserBranch? branchDetails) async {
    var lx = await getVitalSignHistories(branchDetails!.branch!.branchId!, branchDetails.prn!);
    var q1 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'BP');
    var q2 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'BMI');
    var q3 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'PULSE RATE');
    var q4 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'HEIGHT');
    var q5 = lx.firstWhereOrNull((k) => k.vitalSignCode == 'WEIGHT');
    setState(() {
      bpList = q1 == null ? [] : q1.vitalSignsData!;
      bmiList = q2 == null ? [] : q2.vitalSignsData!;
      prList = q3 == null ? [] : q3.vitalSignsData!;
      heightList = q4 == null ? [] : q4.vitalSignsData!;
      weightList = q5 == null ? [] : q5.vitalSignsData!;
    });
  }

  Widget buildChart1() {
    final padding = MediaQuery.of(context).padding;
    final w = Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.all(5.0),
      child: isLoading ? Container() : 
      RefreshIndicator(
        key: refreshIndicatorKey1,
        onRefresh: onRefresh,
        color: kMainColor,
        child: ListView(
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
                initialPage: current1,
                onPageChanged: (index, reason) {
                  setState(() {
                    current1 = index;
                  });
                },
              ),
              items: [
                ChartCard(
                  child: HDLChart(list: hdlList),
                ),
                ChartCard(
                  child: LDLChart(list: ldlList),
                ),
                ChartCard(
                  child: GlucoseChart(list: gluList),
                ),
                ChartCard(
                  child: HemoglobinChart(list: hmgList),
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
                  child: Container(
                    width: 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current1 == i
                        ? kMainColor
                        : const Color(0xFFFFE4E4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
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
      child: isLoading ? Container() : 
      RefreshIndicator(
        key: refreshIndicatorKey0,
        onRefresh: onRefresh,
        color: kMainColor,
        child: ListView(
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
                initialPage: current0,
                onPageChanged: (index, reason) {
                  setState(() {
                    current0 = index;
                  });
                },
              ),
              items: [
                ChartCard(
                  child: BPChart(list: bpList),
                ),
                ChartCard(
                  child: BMIChart(list: bmiList),
                ),
                ChartCard(
                  child: PRChart(list: prList),
                ),
                ChartCard(
                  child: WeightChart(list: weightList),
                ),
                ChartCard(
                  child: HeightChart(list: heightList),
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
                  child: Container(
                    width: 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current0 == i
                        ? kMainColor
                        : const Color(0xFFFFE4E4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
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
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
          toolbarHeight: kAppToolbarHeight + 44,
          automaticallyImplyLeading: false,
          leadingWidth: 100.0,
          backgroundColor: const Color(0xFFF8F8F8),
          leading: const BackBtn(color: Color(0xFF002E50)),
          centerTitle: true,
          title: const Text(
            'Your Health Dashboard',
            style: kTitleTextStyle,
          ),
          elevation: 0.0,
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            controller: tabController,
            onTap: (int i) {
              setState(() {
                tabIndex = i;
              });
            },
            tabs: [
              Tab(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11.0),
                  decoration: BoxDecoration(
                    color: tabIndex == 0 ? kMainColor : const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'Vital Signs',
                    style: kMainTextStyle.copyWith(
                      fontSize: 16.0,
                      color: tabIndex == 0 ? Colors.white : const Color(0xFFB1B1B1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11.0),
                  decoration: BoxDecoration(
                    color: tabIndex == 1 ? kMainColor : const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'Lab',
                    style: kMainTextStyle.copyWith(
                      fontSize: 16.0,
                      color: tabIndex == 1 ? Colors.white : const Color(0xFFB1B1B1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
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
    );
  }
}

class TimeSeriesSales {
  final int time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}