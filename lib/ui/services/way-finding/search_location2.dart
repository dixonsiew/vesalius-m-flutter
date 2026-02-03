import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/way-finding/search_location2_ctrl.dart';
import 'package:vesalius_m_flutter/controllers/services/way_finding_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/way_finding_data.dart';
import 'package:vesalius_m_flutter/services/way_finding_service.dart';

class SearchLocation2 extends StatefulWidget {

  final bool isFrom;
  final String locationTypeCode;

  const SearchLocation2({
    super.key,
    required this.isFrom,
    required this.locationTypeCode,
  });

  @override
  State<SearchLocation2> createState() => _SearchLocation2State();
}

class _SearchLocation2State extends State<SearchLocation2> {

  ScrollController scr = ScrollController();
  late final TextEditingController txtsearch;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final SearchLocation2Ctrl ctrl = Get.put(SearchLocation2Ctrl());
  final WayFindingCtrl wayFindingCtrl = Get.put(WayFindingCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    scr.addListener(scrollListener);
    String s = '';
    txtsearch.text = s;
    ctrl.setKeyword(s);
    load();
  }

  @override
  void dispose() {
    txtsearch.dispose();
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
      List<Location> lx = [];
      ctrl.init();
      ctrl.setIsLoading(true);
      if (!isSearch) {
        lx = await WayFindingService.getAllLocations(widget.locationTypeCode, ctrl.page, kPageSize);
      }
      
      else {
        lx = await WayFindingService.searchLocations(widget.locationTypeCode, ctrl.page, kPageSize, ctrl.keyword);
      }

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
      List<Location> lx = [];
      ctrl.setIsLoadingMore(true);
      if (!isSearch) {
        lx = await WayFindingService.getAllLocations(widget.locationTypeCode, p, kPageSize);
      }
      
      else {
        lx = await WayFindingService.searchLocations(widget.locationTypeCode, p, kPageSize, ctrl.keyword);
      }

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
      handleError(error, loadMore);
    }

    catch (error) {
      ctrl.setIsLoadingMore(false);
      showCustomDialog('Error', error.toString(), 'Dismiss');
    }
  }

  bool get isSearch {
    return ctrl.keyword != '';
  }

  Future<void> onRefresh() async {
    load();
  }

  void onSearch(String s) {
    ctrl.setKeyword(s);
    load();
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kColor6.withValues(alpha: 0.21),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: txtsearch,
        autofocus: false,
        cursorColor: kPrimaryColor,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: kTextColor5,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(color: kColor1.withValues(alpha: 0.35)),
          ),
        ),
        onSubmitted: onSearch,
      ),
    );
  }

  Widget buildList() {
    return ListView.separated(
      controller: scr,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: ctrl.list.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) {
          return buildSearch();
        }

        else if (i == ctrl.list.length + 1) {
          return Obx(() => ctrl.isLoadingMore ? const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: AppLoadMoreIndicator(),
          ) : Container());
        }
    
        final o = ctrl.list[i - 1];
        return InkWell(
          onTap: () async {
            if (widget.isFrom) {
              wayFindingCtrl.setSelectedLocationFrom(o);
            }
            
            else {
              wayFindingCtrl.setSelectedLocationTo(o);
            }

            Get.back();
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  o.locationName,
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
                Text(
                  o.locationFloorCode,
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, i) {
        return Container(
          height: 1.0,
          color: kColor3.withValues(alpha: 0.45),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Search Location',
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
              child: Scrollbar(
                controller: scr,
                child: buildList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}