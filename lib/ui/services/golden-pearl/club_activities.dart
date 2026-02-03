import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/components/kidsclub_image.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/golden-pearl/club_activities_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/goldenclub_data.dart';
import 'package:vesalius_m_flutter/services/clubs_service.dart';

import 'club_activity_detail.dart';

class ClubActivities extends StatefulWidget {

  const ClubActivities({super.key});

  @override
  State<ClubActivities> createState() => _ClubActivitiesState();
}

class _ClubActivitiesState extends State<ClubActivities> {

  late ScrollController scr;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final ClubActivitiesCtrl ctrl = Get.put(ClubActivitiesCtrl());

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
      List<GoldenPearlActivity> lx = await ClubsService.getAllGoldenPearlActivities(ctrl.page, kPageSize);
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
      List<GoldenPearlActivity> lx = await ClubsService.getAllGoldenPearlActivities(p, kPageSize);
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
      return Container();
    }

    return  Scrollbar(
      controller: scr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 11.0),
        child: GridView.builder(
          controller: scr,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: ctrl.list.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            mainAxisExtent: 243.0,
          ),
          itemBuilder: (context, i) {
            if (i == ctrl.list.length) {
              return Obx(() => ctrl.isLoadingMore ? const AppLoadMoreIndicator() : Container());
            }
            
            final o = ctrl.list[i];
            return ClubActivityItem(key: ValueKey(o.goldenActivityId), data: o);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Club Activities',
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

class ClubActivityItem extends StatelessWidget {

  final GoldenPearlActivity data;

  const ClubActivityItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Get.to(() => ClubActivityDetail(data: data));
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KidsActivityImage(
                  img: data.goldenActivityImage,
                  width: double.infinity,
                  height: 148.0,
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    data.goldenActivityName,
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    data.dateRange,
                    style: kTextStyle1.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  margin: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: kColor13.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    '${data.activitySeatsAvailable} seats available',
                    style: kTextStyle1.copyWith(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                      color: kTextColor1,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 8.0, top: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                '${data.activityAttendees} Attendees',
                style: kTextStyle1.copyWith(
                  fontSize: 8.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}