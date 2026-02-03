import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';

import 'outpatient-bill/paid.dart';
import 'outpatient-bill/unpaid.dart';

class OutpatientBill extends StatefulWidget {

  static const String routeName = '/OutpatientBill';

  final int tabIndex;

  const OutpatientBill({
    super.key,
    this.tabIndex = 0,
  });

  @override
  State<OutpatientBill> createState() => _OutpatientBillState();
}

class _OutpatientBillState extends State<OutpatientBill> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<OutpatientBill> {

  int tabIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(tabListener);
    tabIndex = widget.tabIndex;
    tabController.index = tabIndex;
  }

  @override
  void dispose() {
    tabController.removeListener(tabListener);
    tabController.dispose();
    super.dispose();
  }

  void tabListener() {
    setState(() {
      tabIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
              toolbarHeight: kAppToolbarHeight,
              automaticallyImplyLeading: false,
              leadingWidth: 100.0,
              backgroundColor: kBgColor1,
              leading: const BackBtn(color: kTextColor1),
              centerTitle: true,
              title: Text(
                'Bill Payment',
                style: kTextStyle1.copyWith(
                  fontFamily: kFont2,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor,
                ),
              ),
              elevation: 2.0,
              bottom: TabBar(
                indicatorColor: kPrimaryColor,
                controller: tabController,
                onTap: (int i) {
                  setState(() {
                    tabIndex = i;
                  });
                },
                tabs: [
                  Tab(
                    child: Text(
                      'Unpaid',
                      //context.watch<AppointmentModel>().appointmentCount > 0 ? 'Upcoming (${context.watch<AppointmentModel>().appointmentCount})' : 'Upcoming',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: tabIndex == 0 ? kPrimaryColor : kTextColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Paid',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: tabIndex == 1 ? kPrimaryColor : kTextColor2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: kBgColor1,
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: const [
                  Unpaid(),
                  Paid(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}