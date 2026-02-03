import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back-btn.dart';
import 'package:vesalius_m_flutter/components/chart-card.dart';
import 'package:vesalius_m_flutter/components/lab/glucose-chart.dart';
import 'package:vesalius_m_flutter/components/lab/hdl-chart.dart';
import 'package:vesalius_m_flutter/components/lab/hemoglobin-chart.dart';
import 'package:vesalius_m_flutter/components/lab/ldl-chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/bmi-chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/bp-chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/height-chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/pr-chart.dart';
import 'package:vesalius_m_flutter/components/vital-signs/weight-chart.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/data-manager.dart';
import 'package:vesalius_m_flutter/models/patient-data.dart';
import 'package:vesalius_m_flutter/models/user-details.dart';
import 'package:vesalius_m_flutter/services/data-service.dart';

class HealthDashboard extends StatefulWidget {
  
  static final String routeName = 'HealthDashboard';

  @override
  _HealthDashboardState createState() => _HealthDashboardState();
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

  Future<void> loadLabChart(UserBranch branchDetails) async {
    var lx = await getLabHistories(branchDetails.branch.branchId, branchDetails.prn);
    var q1 = lx.firstWhere((k) => k.labCode == 'HDL', orElse: () => null);
    var q2 = lx.firstWhere((k) => k.labCode == 'LDL', orElse: () => null);
    var q3 = lx.firstWhere((k) => k.labCode == 'Glucose', orElse: () => null);
    var q4 = lx.firstWhere((k) => k.labCode == 'Hemoglobin', orElse: () => null);
    setState(() {
      hdlList = q1 == null ? [] : q1.labData;
      ldlList = q2 == null ? [] : q2.labData;
      gluList = q3 == null ? [] : q3.labData;
      hmgList = q4 == null ? [] : q4.labData;
      isLoading = false;
    });
  }

  Future<void> loadVitalSignChart(UserBranch branchDetails) async {
    var lx = await getVitalSignHistories(branchDetails.branch.branchId, branchDetails.prn);
    var q1 = lx.firstWhere((k) => k.vitalSignCode == 'BP', orElse: () => null);
    var q2 = lx.firstWhere((k) => k.vitalSignCode == 'BMI', orElse: () => null );
    var q3 = lx.firstWhere((k) => k.vitalSignCode == 'PULSE RATE', orElse: () => null);
    var q4 = lx.firstWhere((k) => k.vitalSignCode == 'HEIGHT', orElse: () => null);
    var q5 = lx.firstWhere((k) => k.vitalSignCode == 'WEIGHT', orElse: () => null);
    setState(() {
      bpList = q1 == null ? [] : q1.vitalSignsData;
      bmiList = q2 == null ? [] : q2.vitalSignsData;
      prList = q3 == null ? [] : q3.vitalSignsData;
      heightList = q4 == null ? [] : q4.vitalSignsData;
      weightList = q5 == null ? [] : q5.vitalSignsData;
    });
  }

  Widget buildChart1() {
    var padding = MediaQuery.of(context).padding;
    final w = Container(
      padding: EdgeInsets.all(5.0),
      child: isLoading ? Container() : 
      RefreshIndicator(
        key: refreshIndicatorKey1,
        onRefresh: onRefresh,
        child: ListView(
          children: [
            SizedBox(height: 5.0),
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
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current1 == i
                        ? kHealthDashboardBgColor
                        : Color.fromRGBO(0, 0, 0, 0.4),
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
      padding: EdgeInsets.all(5.0),
      child: isLoading ? Container() : 
      RefreshIndicator(
        key: refreshIndicatorKey0,
        onRefresh: onRefresh,
        color: kPrimaryColor,
        child: ListView(
          children: [
            SizedBox(height: 5.0),
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
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current0 == i
                        ? kHealthDashboardBgColor
                        : Color.fromRGBO(0, 0, 0, 0.4),
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
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: kHealthDashboardBgColor),
          backgroundColor: kHealthDashboardBgColor,
          automaticallyImplyLeading: false,
          leadingWidth: 100.0,
          leading: BackBtn(color: Colors.white),
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 160.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: 80.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage('images/icon/home-page-icon/dashboard-icon.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'View Your Health Trending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.black,
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
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
          progressIndicator: AppActivityIndicator(), // AppScalingText('Loading...'),
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