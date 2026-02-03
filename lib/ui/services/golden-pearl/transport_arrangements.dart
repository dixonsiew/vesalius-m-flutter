/*
import 'package:flutter/material.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/ui/services/golden_pearl/to_hospital.dart';

import 'from_hospital.dart';

class TransportArrangement extends StatefulWidget {

  final int tabIndex;

  const TransportArrangement({
    super.key,
    this.tabIndex = 0,
  });

  @override
  State<TransportArrangement> createState() => _TransportArrangementState();
}

class _TransportArrangementState extends State<TransportArrangement> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<TransportArrangement> {

  int tabIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
    });
    tabIndex = widget.tabIndex;
    tabController.index = tabIndex;
  }

  @override
  void dispose() {
    tabController.removeListener(() { });
    tabController.dispose();
    super.dispose();
  }

  Widget buildContent() {
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
                child:
                TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: kPrimaryColor,
                  ),
                  controller: tabController,
                  onTap: (int i) {
                    setState(() {
                      tabIndex = i;
                    });
                  },
                  tabs: [
                    Tab(
                      child:
                      Text(
                        'To Hospital',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: tabIndex == 0 ? kBgColor1 : kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'From Hospital',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: tabIndex == 1 ? kBgColor1 : kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:  TabBarView(
                  controller: tabController,
                  children: const [
                    ToHospital(),
                    FromHospital(),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InnerPage(
      title: "Transport Arrangement",
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
 */