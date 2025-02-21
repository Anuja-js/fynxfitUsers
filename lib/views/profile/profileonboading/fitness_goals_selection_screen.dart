import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/widgets/custom_text.dart';
import '../../../theme.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/custom_elevated_button.dart';

final selectedGoalsProvider = StateProvider<List<String>>((ref) => []);

class FitnessGoalsScreen extends ConsumerWidget {
  final PageController? controller;

  FitnessGoalsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final selectedGoals = ref.watch(selectedGoalsProvider);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "What’s Your Fitness Goal?", fontSize: 13.sp),
            CustomText(
              text: "Personalize Your Fitness Journey\nwith Us!",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,overflow: TextOverflow.visible,
            ),
            CustomText(
              text:
                  "Choose your goals so we can tailor your\nworkout and nutrition plan to fit your needs.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            sh20,
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              alignment: WrapAlignment.center,
              children: [
                GoalOption(
                    label: "Weight Loss",
                    image: "assets/images/one.png",
                    selectedGoals: selectedGoals,
                    ref: ref),
                GoalOption(
                    label: "Muscle Gain",
                    image: "assets/images/Muscle_Gain.png",
                    selectedGoals: selectedGoals,
                    ref: ref),
                GoalOption(
                    label: "General Fitness",
                    image: "assets/images/General_Fitness.png",
                    selectedGoals: selectedGoals,
                    ref: ref),
                GoalOption(
                    label: "Endurance Training",
                    image: "assets/images/Endurance_Training.png",
                    selectedGoals: selectedGoals,
                    ref: ref),
                GoalOption(
                    label: "Flexibility & Mobility",
                    image: "assets/images/Flexibility_&_Mobility.png",
                    selectedGoals: selectedGoals,
                    ref: ref),
                GoalOption(
                    label: "Mind & Body Wellness",
                    image: "assets/images/Mind_&_Body_Wellness.png",
                    selectedGoals: selectedGoals,
                    ref: ref),
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
                  if (selectedGoals.isNotEmpty) {
                    viewModel.updateFitnessGoal(selectedGoals.toString());
                    controller?.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: CustomText(
                        text: "Please select at least one fitness goal",
                        color: AppThemes.darkTheme.scaffoldBackgroundColor,
                      )),
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

class GoalOption extends StatelessWidget {
  final String label;
  final String image;
  final List<String> selectedGoals;
  final WidgetRef ref;

  GoalOption(
      {required this.label,
      required this.image,
      required this.selectedGoals,
      required this.ref});

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedGoals.contains(label);

    return GestureDetector(
      onTap: () {
        List<String> updatedGoals = List.from(selectedGoals);
        if (isSelected) {
          updatedGoals.remove(label);
        } else {
          updatedGoals.add(label);
        }
        ref.read(selectedGoalsProvider.notifier).state = updatedGoals;
      },
      child: Column(
        children: [
          Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppThemes.darkTheme.primaryColor.withOpacity(0.5)
                  : AppThemes.darkTheme.appBarTheme.foregroundColor,
              border: isSelected
                  ? Border.all(
                      color: AppThemes.darkTheme.primaryColor, width: 2)
                  : null,
            ),
            child: CircleAvatar(
              radius: 45.w,
              backgroundColor: isSelected
                  ? Colors.grey.withOpacity(0.5)
                  : AppThemes.darkTheme.appBarTheme.foregroundColor,
              backgroundImage: AssetImage(image),
            ),
          ),
          sh10,
          CustomText(
              text: label,
              fontSize: 10.sp,
              color: AppThemes.darkTheme.appBarTheme.foregroundColor!),
        ],
      ),
    );
  }
}
