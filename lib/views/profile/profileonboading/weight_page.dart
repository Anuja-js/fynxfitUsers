import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/widgets/custom_elevated_button.dart';
import '../../../core/utils/constants.dart';
import '../../../theme.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/custom_text.dart';

class WeightScreen extends ConsumerStatefulWidget {
  final PageController? controller;

  const WeightScreen({required this.controller, Key? key}) : super(key: key);

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  bool isKgUnit = true;
  late double selectedWeight;

  @override
  void initState() {
    super.initState();
    selectedWeight = 75.0;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Please Fill The Details", fontSize: 13.sp),
            CustomText(
              text: "Anuja, What Is Your Weight?",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Help us customize your fitness plan by selecting your current weight.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            sh20,

            // Unit Toggle Button
            Container(
              decoration: BoxDecoration(
                color: AppThemes.darkTheme.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25.r),
              ),
              height: 50.h,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!isKgUnit) {
                          setState(() {
                            isKgUnit = true;
                            selectedWeight = selectedWeight / 2.20462;
                          });
                          viewModel.updateWeight(selectedWeight);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isKgUnit ? AppThemes.darkTheme.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Text(
                          'KG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isKgUnit ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isKgUnit) {
                          setState(() {
                            isKgUnit = false;
                            selectedWeight = selectedWeight * 2.20462;
                          });
                          viewModel.updateWeight(selectedWeight);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isKgUnit ? AppThemes.darkTheme.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Text(
                          'LB',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isKgUnit ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Weight Scale
            WeightScaleWidget(
              initialWeight: selectedWeight,
              onWeightChanged: (weight) {
                setState(() {
                  selectedWeight = weight;
                });
                viewModel.updateWeight(weight);
              },
              isKgUnit: isKgUnit,
            ),

            SizedBox(height: 40.h),

            // Weight Display
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    selectedWeight.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isKgUnit ? 'kg' : 'lb',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Next Button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text: "Next",
                onPressed: () {
                  widget.controller?.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }}

  class WeightScaleWidget extends StatefulWidget {
  final double initialWeight;
  final ValueChanged<double> onWeightChanged;
  final bool isKgUnit;

  const WeightScaleWidget({
  Key? key,
  required this.initialWeight,
  required this.onWeightChanged,
  required this.isKgUnit,
  }) : super(key: key);

  @override
  _WeightScaleWidgetState createState() => _WeightScaleWidgetState();
  }

  class _WeightScaleWidgetState extends State<WeightScaleWidget> {
  late FixedExtentScrollController _scrollController;
  late List<double> weightValues;

  @override
  void initState() {
  super.initState();
  _setupScale();
  }

  void _setupScale() {
  double minWeight = widget.isKgUnit ? 30.0 : 66.0; // 30kg or 66lb
  double maxWeight = widget.isKgUnit ? 200.0 : 440.0; // 200kg or 440lb
  double step = widget.isKgUnit ? 1.0 : 2.0; // 1kg step or 2lb step

  weightValues = List.generate(
  ((maxWeight - minWeight) ~/ step).toInt() + 1,
  (index) => minWeight + (index * step),
  );

  int initialIndex = weightValues.indexOf(widget.initialWeight);
  if (initialIndex == -1) {
  initialIndex = weightValues.length ~/ 2; // Default to middle
  }

  _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  Widget build(BuildContext context) {
  return Center(
  child: SizedBox(
  height: 200,
  child: ListWheelScrollView.useDelegate(
  controller: _scrollController,
  itemExtent: 50,
  physics: FixedExtentScrollPhysics(),
  onSelectedItemChanged: (index) {
  widget.onWeightChanged(weightValues[index]);
  },
  childDelegate: ListWheelChildBuilderDelegate(
  builder: (context, index) {
  return Center(
  child: Text(
  weightValues[index].toStringAsFixed(0),
  style: TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  );
  },
  childCount: weightValues.length,
  ),
  ),
  ),
  );
  }

  @override
  void dispose() {
  _scrollController.dispose();
  super.dispose();
  }
  }


