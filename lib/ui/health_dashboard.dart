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
  
  static const String routeName = 'HealthDashboard';

  const HealthDashboard({Key? key}) : super(key: key);

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {

  List<VitalSignsData> bpList = [];
  List<VitalSignsData> bmiList = [];
  List<VitalSignsData> prList = [];
  List<VitalSignsData> heightList = [];
  List<VitalSignsData> weightList = [];

  List<LabData> hdlList = [];
  List<LabData> ldlList = [];
  List<LabData> gluList = [];
  List<LabData> hmgList = [];

  int current0 = 0;
  int current1 = 0;
  bool isLoading = false;
  final CarouselController _controller = CarouselController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey0 = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey1 = GlobalKey<RefreshIndicatorState>();

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
    var padding = MediaQuery.of(context).padding;
    final w = Container(
      padding: const EdgeInsets.all(5.0),
      child: isLoading ? Container() : 
      RefreshIndicator(
        key: refreshIndicatorKey1,
        onRefresh: onRefresh,
        child: ListView(
          children: [
            const SizedBox(height: 5.0),
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: false,
                height: MediaQuery.of(context).size.height - 280.0 - padding.top - padding.bottom,
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
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current1 == i
                        ? kHealthDashboardBgColor
                        : const Color.fromRGBO(0, 0, 0, 0.4),
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
    var padding = MediaQuery.of(context).padding;
    final w = Container(
      padding: const EdgeInsets.all(5.0),
      child: isLoading ? Container() : 
      RefreshIndicator(
        key: refreshIndicatorKey0,
        onRefresh: onRefresh,
        color: kPrimaryColor,
        child: ListView(
          children: [
            const SizedBox(height: 5.0),
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: false,
                height: MediaQuery.of(context).size.height - 280.0 - padding.top - padding.bottom,
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
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current0 == i
                        ? kHealthDashboardBgColor
                        : const Color.fromRGBO(0, 0, 0, 0.4),
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
          // brightness: Brightness.dark,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kHealthDashboardBgColor),
          backgroundColor: kHealthDashboardBgColor,
          automaticallyImplyLeading: false,
          leadingWidth: 100.0,
          leading: const BackBtn(color: Colors.white),
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 160.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Image.asset(
                          'images/icon/page-header-icon/dashboard-icon.png',
                          width: 65.0,
                          height: 50.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20.0, top: 40.0),
                        child: Text(
                          'View Your Health Trending',
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
                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.black,
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: kTitleFont,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontFamily: kTitleFont,
                  ),
                  tabs: [
                    Tab(
                      text: 'Vital Signs',
                    ),
                    Tab(
                      text: 'Lab',
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const AppActivityIndicator(), // AppScalingText('Loading...'),
          child: SafeArea(
            child: TabBarView(
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