import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/controllers/services/way-finding/search_location_ctrl.dart';
import 'package:vesalius_m_flutter/helpers.dart';
import 'package:vesalius_m_flutter/models/way_finding_data.dart';
import 'package:vesalius_m_flutter/services/way_finding_service.dart';
import 'package:vesalius_m_flutter/ui/services/way-finding/search_location2.dart';

// https://www.figma.com/design/cT4oYFlZM988czBEhXCDdU/IH-Hospital-Mobile-App?node-id=8344-17884&t=b5knqhZrB1es5V8e-0

class SearchLocation extends StatefulWidget {

  final bool isFrom;

  const SearchLocation({
    super.key,
    this.isFrom = true,
  });

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  ScrollController scr = ScrollController();
  late final TextEditingController txtsearch;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final SearchLocationCtrl ctrl = Get.put(SearchLocationCtrl());

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
      List<LocationType> lx = [];
      ctrl.init();
      ctrl.setIsLoading(true);
      if (!isSearch) {
        lx = await WayFindingService.getAllLocationTypes(ctrl.page, kPageSize);
      }

      else {
        lx = await WayFindingService.searchLocationTypes(ctrl.page, kPageSize, ctrl.keyword);
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
      List<LocationType> lx = [];
      ctrl.setIsLoadingMore(true);
      if (!isSearch) {
        lx = await WayFindingService.getAllLocationTypes(p, kPageSize);
      }
      
      else {
        lx = await WayFindingService.searchLocationTypes(p, kPageSize, ctrl.keyword);
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
          onTap: () {
            Get.to(() => SearchLocation2(isFrom: widget.isFrom, locationTypeCode: o.locationTypeCode));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  o.locationTypeName,
                  style: kTextStyle1.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: kTextColor1,
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
      title: 'Search Location Type',
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