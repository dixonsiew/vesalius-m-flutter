import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vesalius_m_flutter/components/app_shared.dart';
import 'package:vesalius_m_flutter/components/inner_page.dart';
import 'package:vesalius_m_flutter/constants.dart';

class SelectDate extends StatefulWidget {

  final DateTime? selected;
  final DateTime startDate;
  final DateTime? endDate;
  //final List<DateTime> list;

  const SelectDate({
    super.key,
    this.selected,
    required this.startDate,
    this.endDate,
  });

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {

  final SelectDateCtrl ctrl = Get.put(SelectDateCtrl());

  @override
  void initState() {
    super.initState();
    ctrl.setData(widget.selected);
  }

  // String getDateStr(DateTime? dt) {
  //   if (dt == null) {
  //     return '';
  //   }

  //   return formatDate(dt, [dd, ' ', M, ' ', yyyy]);
  // }

  Obx buildCalendar() {
    final config = CalendarDatePicker2Config(
      centerAlignModePicker: true,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      dayBuilder: ({required date, decoration, isDisabled, isSelected, isToday, textStyle}) {
        if (isToday == true && isSelected == false) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: const Color(0xFF44A1E4),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle?.copyWith(color: Colors.white),
              ),
            ),
          );
        }

        else if (isSelected == true) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: textStyle,
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(5.0),
            border: isDisabled == true ? null : Border.all(color: kPrimaryColor),
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: textStyle,
            ),
          ),
        );
      },
      lastMonthIcon: Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: kPrimaryColor),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_left,
            color: kPrimaryColor,
            size: 24.0,
          ),
        ),
      ),
      nextMonthIcon: Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: kPrimaryColor),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_right,
            color: kPrimaryColor,
            size: 24.0,
          ),
        ),
      ),
      firstDayOfWeek: 1,
      firstDate: widget.startDate,
      lastDate: widget.endDate,
      controlsTextStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: kPrimaryColor,
      ),
      dayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: kTextColor1,
      ),
      disabledDayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
      selectedDayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      selectedDayHighlightColor: kPrimaryColor,
      todayTextStyle: kTextStyle1.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
    return Obx(() =>
      CalendarDatePicker2(
        config: config,
        value: [ctrl.data],
        onValueChanged: (dates) {
          DateTime date = dates.first;
          ctrl.setData(date);
        },
        onDisplayedMonthChanged: (dt) {
          ctrl.setData(dt);
        },
      ),
    );
  }

  /* Obx buildCalendar() {
    final calendarCarousel = Obx(() =>
      CalendarCarousel<Event>(
        height: 410.0,
        customGridViewPhysics: const NeverScrollableScrollPhysics(),
        staticSixWeekFormat: true,
        showOnlyCurrentMonthDate: true,
        headerTextStyle: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          color: kPrimaryColor,
        ),
        leftButtonIcon: Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: kPrimaryColor),
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_left,
              color: kPrimaryColor,
              size: 24.0,
            ),
          ),
        ),
        rightButtonIcon: Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: kPrimaryColor),
          ),
          child: const Center(
            child: Icon(
              Icons.chevron_right,
              color: kPrimaryColor,
              size: 24.0,
            ),
          ),
        ),
        dayButtonColor: kSecondaryColor,
        todayBorderColor: const Color(0xFF44A1E4),
        todayButtonColor: const Color(0xFF44A1E4),
        selectedDayBorderColor: kPrimaryColor,
        selectedDayButtonColor: kPrimaryColor,
        prevDaysTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
        daysTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
        todayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        selectedDayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        weekdayTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFADADAD),
        ),
        weekendTextStyle: kTextStyle1.copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
        iconColor: kPrimaryColor,
        daysHaveCircularBorder: false,
        thisMonthDayBorderColor: kSecondaryColor,
        selectedDateTime: ctrl.data,
        minSelectedDate: widget.startDate,
        maxSelectedDate: widget.endDate,
        onDayPressed: (date, events) {
          ctrl.setData(date);
        },
        onCalendarChanged: (DateTime dt) {
          ctrl.setData(dt);
        },
      ),
    );

    return calendarCarousel;
  } */

  Widget buildContent() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: buildCalendar(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'OK',
              onPressed: () {
                Get.back(result: ctrl.data);
              },
            ),
          ),
        ),
      ],
    );
  }

  /* Widget buildContent00() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.list.length,
              itemBuilder: (context, i) {
                return ListTile(
                  onTap: () {
                    ctrl.setData(widget.list[i]);
                  },
                  title: Text(
                    getDateStr(widget.list[i]),
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor1,
                    ),
                  ),
                  trailing: Obx(() => getDateStr(widget.list[i]) == getDateStr(ctrl.data) ? 
                  const Icon(
                    Icons.check,
                    color: kPrimaryColor,
                  ) : const SizedBox(
                    width: 24.0,
                    height: 24.0,
                  )),
                );
              },
              separatorBuilder: (context, i) {
                return Container(
                  height: 1.0,
                  color: const Color(0xFFDBDBDB),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
              text: 'OK',
              onPressed: () {
                Get.back(result: ctrl.data);
              },
            ),
          ),
        ),
      ],
    );
  } */

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Select Date',
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class SelectDateCtrl extends GetxController {

  final _data = Rx<DateTime?>(null);

  void setData(DateTime? s) {
    _data.value = s;
  }

  DateTime? get data => _data.value;
}