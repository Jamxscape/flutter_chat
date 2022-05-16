library date_ranger;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part './parts/primary_page.dart';
part './parts/secondary_page.dart';
part './parts/enums.dart';
part './parts/extensions.dart';
part './parts/inherted_ranger.dart';
part './parts/type_defs.dart';

class DateRanger extends StatefulWidget {
  ///A date picker for selecting single dates and date ranges
  const DateRanger({
    Key? key,
    this.borderColors,
    this.backgroundColor,
    this.errorColor,
    this.rangeBackground,
    this.activeItemBackground,
    this.initialRange,
    this.initialDate,
    this.onRangeChanged,
    this.inRangeTextColor,
    this.outOfRangeTextColor,
    this.rangerType = DateRangerType.range,
    this.outputDateFormat,
    this.activeDateFontSize = 16.0,
    this.horizontalPadding = 8,
    this.itemHeight = 32,
    this.runSpacing = 10,
    this.activeDateBottomSpace = 10,
    this.showDoubleTapInfo = true,
  }) : super(key: key);

  ///The border color of the active date type __Start date__ or __End date__ and the selected Day.
  ///It is also used as the color of the chevrons that control moving from one month to another.
  final Color? borderColors;

  ///The background color of the date picker.
  final Color? backgroundColor;

  ///The text color for errors that occur when selecting date.
  final Color? errorColor;

  ///The background color of dates that are in range of the selected __Start__ and **End** dates.
  final Color? rangeBackground;

  ///The background color of active dates both **Start** and **End**  dates.
  final Color? activeItemBackground;

  ///The text color of dates(days) that are in range of the selected __Start__ and __End__ dates.
  final Color? inRangeTextColor;

  ///The initial [DateTimeRange] of the picker.
  ///
  ///The picker jumps to the month of the __start date__ on initialization.
  final DateTimeRange? initialRange;

  ///The initial Date of the picker.
  ///
  /// You can use this for and [DateRangerType].
  ///
  /// Usually used with [DateRangerType.single].<bt/>
  /// For [DateRangerType.range] the __start__ and __end__ dates are set to the [initialDate].
  final DateTime? initialDate;

  ///A callback function for the selected date(s).
  ///
  /// For [DateRangerType.single] both the __start__ and __end__ dates are set to the selected date
  final OnRangeChanged? onRangeChanged;

  ///The text color of dates that are not in the range of the selected __start__ and __end__ dates.
  ///
  /// Also the text color of titles for the selection output _Start Date_  and _End date_
  final Color? outOfRangeTextColor;

  ///Defines the type of picker.
  ///
  /// [DateRangerType.range] is the default and the picker selects two dates,
  /// __Start Date__ and __End Date__
  final DateRangerType rangerType;

  ///The DateFormat used for the selection outputs
  final DateFormat? outputDateFormat;

  ///FontSize of the text showing the month and year of the picker.
  ///
  /// Affects the height of the main picker.
  /// See also
  /// - [activeDateBottomSpace]
  final double activeDateFontSize;

  ///The horizontal padding of the main picker.
  ///Affects the height of the main picker
  final double horizontalPadding;

  ///The height of each date(_days_).
  ///
  /// Affects the height of the main picker.
  final double itemHeight;

  ///The vertical space between dates(_days_).
  ///
  /// Affects the height of the main picker.
  final double runSpacing;

  ///The minimum vertical space between the activeDate and the dates(_days).
  final double activeDateBottomSpace;

  final bool showDoubleTapInfo;

  @override
  _DateRangerState createState() => _DateRangerState();
}

class _DateRangerState extends State<DateRanger>
    with SingleTickerProviderStateMixin {
  late double itemWidth = widget.itemHeight + (widget.itemHeight * 0.25);
  late var isRange = widget.rangerType == DateRangerType.range;
  late final DateTime initialDate =
      isRange ? DateTime.now() : widget.initialDate ?? DateTime.now();
  final showInfo = ValueNotifier(false);
  late ValueNotifier<DateTimeRange> dateRange = ValueNotifier(
      widget.initialRange ??
          DateTimeRange(
              end: DateUtils.dateOnly(initialDate),
              start: DateUtils.dateOnly(initialDate)));
  late var activeYear = dateRange.value.start.year;
  late var tabController = TabController(length: 12, vsync: this);
  final activeTab = ValueNotifier(0);
  var selectingStart = true;
  final errorText = ValueNotifier('');
  var navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      tabController.addListener(() {
        final index = tabController.index;
        activeTab.value = index;
      });
      tabController.animateTo(dateRange.value.start.month - 1);
      if (widget.showDoubleTapInfo) {
        showInfo.value = true;
        await Future.delayed(
            const Duration(seconds: 3), () => showInfo.value = false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    resetForSingleCase();
    return Theme(
      data: ThemeData(
        brightness: Theme.of(context).brightness,
        colorScheme: (Theme.of(context).brightness == Brightness.light
                ? const ColorScheme.light()
                : const ColorScheme.dark())
            .copyWith(
          secondary: widget.rangeBackground,
          error: widget.errorColor,
          background: widget.backgroundColor,
          primary: widget.activeItemBackground,
          onPrimary: widget.inRangeTextColor,
          onBackground: widget.outOfRangeTextColor,
          primaryVariant: widget.borderColors,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                pickerOutput(),
                if (widget.rangerType == DateRangerType.range) ...[
                  const Center(
                    child: SizedBox(
                      width: 32,
                      child: Divider(
                        endIndent: 12,
                        indent: 12,
                        thickness: 2,
                      ),
                    ),
                  ),
                  pickerOutput(false)
                ],
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: showInfo,
            builder: (context, value, child) => AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: value ? 1 : 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Text(
                    '长按定位日期',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                )),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints:
                    BoxConstraints(maxHeight: calculateHeight(constraints)),
                padding: EdgeInsets.symmetric(
                        horizontal: widget.horizontalPadding, vertical: 24)
                    .copyWith(top: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black12.withOpacity(0.6),
                    width: 0.1,
                  ),
                ),
                child: InheritedRanger(
                  selectingStart: selectingStart,
                  activeYear: activeYear,
                  tabController: tabController,
                  rangerType: widget.rangerType,
                  activeTab: activeTab,
                  dateRange: dateRange,
                  navKey: navKey,
                  itemHeight: widget.itemHeight,
                  itemWidth: itemWidth,
                  runSpacing: widget.runSpacing,
                  activeDateBottomSpace: widget.activeDateBottomSpace,
                  activeDateFontSize: widget.activeDateFontSize,
                  child: Navigator(
                    key: navKey,
                    onGenerateRoute: (settings) {
                      Widget widget;
                      if (settings.name == '/') {
                        widget = PrimaryPage(
                          onNewDate: onNewDate,
                          onRangeChanged: onRangeChanged,
                          onError: onError,
                        );
                      } else {
                        widget = SecondaryPage(
                          dateTime: settings.arguments! as DateTime,
                        );
                      }
                      return MaterialPageRoute<void>(
                        builder: (context) => widget,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: errorText,
            builder: (context, value, child) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(seconds: 2),
              child: Text(
                value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateHeight(BoxConstraints constraints) {
    final itemsPerRole =
        (constraints.maxWidth - (widget.horizontalPadding * 2)) ~/ itemWidth;
    const maxDaysPerMonth = 31;
    return maxDaysPerMonth /
        itemsPerRole *
        (widget.itemHeight +
            widget.runSpacing +
            widget.activeDateBottomSpace +
            widget.activeDateFontSize);
  }

  ///adjust selections for single case on state changes with different rangeTypes
  void resetForSingleCase() {
    if (widget.rangerType == DateRangerType.single) {
      selectingStart = true;
      final currentRange = dateRange.value;
      if (currentRange.start.compareTo(currentRange.end) != 0)
        dateRange.value = currentRange.copyWith(end: currentRange.start);
    }
  }

  void onRangeChanged(DateTimeRange range) {
    if (widget.onRangeChanged != null) {
      widget.onRangeChanged!(range);
    }
  }

  void onNewDate(DateTime newDate) {
    return setState(() {
      activeYear = newDate.year;
      tabController.animateTo(newDate.month - 1);
    });
  }

  Widget pickerOutput([bool start = true]) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          selectingStart = start;
        }),
        onLongPress: () {
          final range = dateRange.value;
          setState(() {
            activeYear = (start ? range.start : range.end).year;
          });
          tabController
              .animateTo(start ? range.start.month - 1 : range.end.month - 1);
        },
        child: Builder(
          builder: (context) {
            final isRange = widget.rangerType == DateRangerType.range;
            return AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectingStart && start || !selectingStart && !start
                      ? Theme.of(context).colorScheme.primaryVariant
                      : Colors.transparent,
                ),
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(7),
              ),
              duration: const Duration(milliseconds: 100),
              child: Column(
                crossAxisAlignment: isRange
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRange ? '${start ? '开始' : '结束'}日期' : '日期',
                    maxLines: 1,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.3),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ValueListenableBuilder<DateTimeRange>(
                    valueListenable: dateRange,
                    builder: (context, value, child) => FittedBox(
                      child: Text(
                        (widget.outputDateFormat ?? DateFormat.yMd())
                            .format(start ? value.start : value.end),
                        maxLines: 1,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onError(String error) async {
    errorText.value = error;
    await Future.delayed(
      const Duration(seconds: 1),
      () => errorText.value = '',
    );
  }
}
