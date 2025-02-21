import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/widgets/custom_text.dart';
import '../../../theme.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/custom_elevated_button.dart';

final selectedGenderProvider = StateProvider<String?>((ref) => null);

class GenderSelectionScreen extends ConsumerWidget {
  final PageController? controller;

  GenderSelectionScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final selectedGender = ref.watch(selectedGenderProvider);

    return Scaffold(backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Please Select An Option", fontSize: 13.sp),
            CustomText(text: "Tell Us Who You Are", fontSize: 18.sp, fontWeight: FontWeight.bold),
            CustomText(
              text: "This helps us personalize your fitness experience.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GenderOption(label: "Female", image: "assets/images/female.png", selectedGender: selectedGender, ref: ref),
                GenderOption(label: "Male", image: "assets/images/male.png", selectedGender: selectedGender, ref: ref),
                GenderOption(label: "Other", image: "assets/images/other.png", selectedGender: selectedGender, ref: ref),
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
                  if (selectedGender != null) {
                    viewModel.updateGender(selectedGender);
                    controller?.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select your gender")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderOption extends StatelessWidget {
  final String label;
  final String image;
  final String? selectedGender;
  final WidgetRef ref;

  GenderOption({required this.label, required this.image, required this.selectedGender, required this.ref});

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedGender == label;

    return GestureDetector(
      onTap: () {
        ref.read(selectedGenderProvider.notifier).state = label;
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        width: 90.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: isSelected? Colors.grey.withOpacity(0.5):AppThemes.darkTheme.appBarTheme.foregroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 35.h, width: 35.w),
           sh10,
            CustomText(text: label, color: AppThemes.darkTheme.dialogBackgroundColor),
          ],
        ),
      ),
    );
  }
}
