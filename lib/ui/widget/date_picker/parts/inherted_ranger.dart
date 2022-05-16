part of '../date_ranger.dart';

class InheritedRanger extends InheritedWidget {
  const InheritedRanger({
    Key? key,
    required Widget child,
    required this.activeYear,
    required this.activeTab,
    required this.tabController,
    required this.dateRange,
    required this.selectingStart,
    required this.navKey,
    required this.rangerType,
    required this.itemHeight,
    required this.runSpacing,
    required this.activeDateBottomSpace,
    required this.activeDateFontSize,
    required this.itemWidth,
  }) : super(child: child, key: key);

  final int activeYear;
  final ValueNotifier<int> activeTab;
  final TabController tabController;
  final ValueNotifier<DateTimeRange> dateRange;
  final bool selectingStart;
  final GlobalKey<NavigatorState> navKey;
  final DateRangerType rangerType;
  final double itemHeight;
  final double runSpacing;
  final double activeDateBottomSpace;
  final double activeDateFontSize;
  final double itemWidth;

  @override
  bool updateShouldNotify(covariant InheritedRanger oldWidget) => true;

  static InheritedRanger of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedRanger>()!;
}
