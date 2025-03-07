import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';
import '../../../theme.dart';
import '../../../viewmodels/fitness_goal_view_model.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/customs/custom_elevated_button.dart';

final selectedGoalsProvider = StateProvider<List<String>>((ref) => []);

class FitnessGoalsScreen extends ConsumerWidget {
  final PageController? controller;

  FitnessGoalsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoals = ref.watch(selectedGoalsProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final goalsState = ref.watch(fitnessGoalViewModelProvider);

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
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.visible,
            ),
            CustomText(
              text: "Choose your goals so we can tailor your\nworkout and nutrition plan to fit your needs.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            sh20,

            // Display goals dynamically from Firestore
            goalsState.when(
              data: (goals) => Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                alignment: WrapAlignment.center,
                children: goals
                    .map((goal) => GoalOption(
                  label: goal.title,
                  image: goal.imageUrl,
                  selectedGoals: selectedGoals,
                  ref: ref,
                ))
                    .toList(),
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: CustomText(text: "Error loading goals")),
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
                    viewModel.updateFitnessGoal(selectedGoals);
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
                        ),
                      ),
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

  GoalOption({
    required this.label,
    required this.image,
    required this.selectedGoals,
    required this.ref,
  });

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
                  ? Border.all(color: AppThemes.darkTheme.primaryColor, width: 2)
                  : null,
            ),
            child: CircleAvatar(
              radius: 45.w,
              backgroundColor: isSelected
                  ? Colors.grey.withOpacity(0.5)
                  : AppThemes.darkTheme.appBarTheme.foregroundColor,
              backgroundImage: image.isNotEmpty
                  ? NetworkImage(image) // ✅ Load image from Firestore
                  : AssetImage("assets/images/goal_placeholder.png") as ImageProvider,
            ),
          ),
          sh10,
          CustomText(
            text: label,
            fontSize: 10.sp,
            color: AppThemes.darkTheme.appBarTheme.foregroundColor!,
          ),
        ],
      ),
    );
  }
}
