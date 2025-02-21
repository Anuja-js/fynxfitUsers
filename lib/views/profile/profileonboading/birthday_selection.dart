import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/constants.dart';
import '../../../theme.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text.dart';

class BirthdayScreen extends ConsumerWidget {
  final PageController? controller;

  BirthdayScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final viewModelNotifier = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Please Fill The Details", fontSize: 13.sp),
            CustomText(
              text: "Anuja, when is your birthday?",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "This helps us personalize your fitness plan based on your age.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            sh20,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day Dropdown
                DropdownButton<int>(
                  value: viewModel.birthday?.day,
                  underline: SizedBox(),
                  menuMaxHeight: 200.h,
                  hint: CustomText(text: "Day"),
                  items: List.generate(31, (index) => index + 1)
                      .map((day) => DropdownMenuItem(value: day, child: Text("$day")))
                      .toList(),
                  onChanged: (day) {
                    if (day != null) {
                      viewModelNotifier.updateBirthday(
                        DateTime(viewModel.birthday?.year ?? DateTime.now().year,
                            viewModel.birthday?.month ?? 1, day),
                      );
                    }
                  },
                ),

                // Month Dropdown
                DropdownButton<int>(
                  value: viewModel.birthday?.month,
                  underline: SizedBox(),
                  menuMaxHeight: 200.h,
                  hint: CustomText(text: "Month"),
                  items: List.generate(12, (index) => index + 1)
                      .map((month) => DropdownMenuItem(value: month, child: Text("$month")))
                      .toList(),
                  onChanged: (month) {
                    if (month != null) {
                      viewModelNotifier.updateBirthday(
                        DateTime(viewModel.birthday?.year ?? DateTime.now().year,
                            month, viewModel.birthday?.day ?? 1),
                      );
                    }
                  },
                ),

                // Year Dropdown
                DropdownButton<int>(
                  value: viewModel.birthday?.year,
                  elevation: 0,
                  underline: SizedBox(),
                  menuMaxHeight: 200.h,
                  hint: CustomText(text: "Year"),
                  items: List.generate(100, (index) => DateTime.now().year - index)
                      .map((year) => DropdownMenuItem(value: year, child: Text("$year")))
                      .toList(),
                  onChanged: (year) {
                    if (year != null) {
                      viewModelNotifier.updateBirthday(
                        DateTime(year, viewModel.birthday?.month ?? 1, viewModel.birthday?.day ?? 1),
                      );
                    }
                  },
                ),
              ],
            ),

            Spacer(),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text: "Next",
                onPressed: () {
                  _validateAndProceed(context, viewModel, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndProceed(BuildContext context, ProfileState viewModel, PageController? controller) {
    if (viewModel.birthday == null) {
      _showError(context, "Please select your birthday.");
      return;
    }

    int userAge = DateTime.now().year - viewModel.birthday!.year;
    if (DateTime.now().month < viewModel.birthday!.month ||
        (DateTime.now().month == viewModel.birthday!.month && DateTime.now().day < viewModel.birthday!.day)) {
      userAge--;
    }

    if (userAge < 5) {
      _showError(context, "You must be at least 5 years old to use this app.");
      return;
    }

    controller?.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
