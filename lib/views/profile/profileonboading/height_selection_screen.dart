import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../theme.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/customs/custom_elevated_button.dart';
import '../../../widgets/customs/custom_text.dart';

class HeightScreen extends ConsumerStatefulWidget {
  final PageController? controller;

  const HeightScreen({required this.controller, Key? key}) : super(key: key);

  @override
  ConsumerState<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends ConsumerState<HeightScreen> {
  bool isCmUnit = true;
  late double selectedHeight;

  @override
  void initState() {
    super.initState();
    selectedHeight = 170.0;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final nameviewModel = ref.read(profileViewModelProvider);
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Please Fill The Details", fontSize: 13.sp),
            CustomText(
              text: "${nameviewModel.name}, What Is Your Height?",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Help us customize your fitness plan by selecting your height.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            SizedBox(height: 20.h),

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
                        if (!isCmUnit) {
                          setState(() {
                            isCmUnit = true;
                            selectedHeight = selectedHeight * 2.54;
                          });
                          viewModel.updateHeight(selectedHeight);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isCmUnit ? AppThemes.darkTheme.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Text(
                          'CM',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCmUnit ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isCmUnit) {
                          setState(() {
                            isCmUnit = false;
                            selectedHeight = selectedHeight / 2.54;
                          });
                          viewModel.updateHeight(selectedHeight);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isCmUnit ? AppThemes.darkTheme.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Text(
                          'IN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isCmUnit ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Height Scale
            HeightScaleWidget(
              initialHeight: selectedHeight,
              onHeightChanged: (height) {
                setState(() {
                  selectedHeight = height;
                });
                viewModel.updateHeight(height);
              },
              isCmUnit: isCmUnit,
            ),


            SizedBox(height: 40.h),

            // Height Display
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    selectedHeight.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isCmUnit ? 'cm' : 'in',
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
                onPressed: () async {viewModel.updateHeight(selectedHeight);
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
  }
}

class HeightScaleWidget extends StatelessWidget {
  final double initialHeight;
  final ValueChanged<double> onHeightChanged;
  final bool isCmUnit;

  const HeightScaleWidget({
    Key? key,
    required this.initialHeight,
    required this.onHeightChanged,
    required this.isCmUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Slider(
        value: initialHeight,
        min: isCmUnit ? 99 : 39,
        max: isCmUnit ? 220 : 87,
        divisions: (isCmUnit ? 120 : 48),
        label: initialHeight.toStringAsFixed(0),
        onChanged: (double value) {
          onHeightChanged(value);
        },
      ),
    );
  }
}
