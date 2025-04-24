import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import 'package:fynxfituser/widgets/home/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressCardSession extends StatelessWidget {
  const ProgressCardSession({
    super.key,
    required this.currentDate,required this.isDark,
    required this.hours,
  });

  final DateTime currentDate;
  final List<double> hours;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         CustomText(text:
            'My Progress',
        fontSize: 15.sp, fontWeight: FontWeight.w500,color: isDark
                 ? AppThemes.lightTheme.scaffoldBackgroundColor
                 : AppThemes.darkTheme.scaffoldBackgroundColor,
          ),
          CustomText(text:
            'January ${currentDate.day}',

              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppThemes.darkTheme.primaryColor,

          ),
          sh10,
          SizedBox(
            height: 200.h,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 5,
                interval: 1,
              ),
              series: <ChartSeries>[
                LineSeries<ChartData, String>(
                  dataSource: List.generate(hours.length, (index) {
                    return ChartData((index + 12).toString(), hours[index]);
                  }),
                  xValueMapper: (ChartData data, _) => data.day,
                  yValueMapper: (ChartData data, _) => data.hours,
                  color: AppThemes.darkTheme.primaryColor,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
