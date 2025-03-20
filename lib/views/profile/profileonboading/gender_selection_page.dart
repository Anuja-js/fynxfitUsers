import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/core/utils/constants.dart';
import 'package:fynxfituser/widgets/customs/custom_text_field.dart';
import '../../../theme.dart';
import '../../../viewmodels/profile_view_model.dart';
import '../../../widgets/customs/custom_elevated_button.dart';
import '../../../widgets/customs/custom_text.dart';

final selectedGenderProvider = StateProvider<String?>((ref) => null);
final userNameProvider = StateProvider<String?>((ref) => null);

class GenderSelectionScreen extends ConsumerWidget {
  final PageController? controller;
  final String userId;

  GenderSelectionScreen({required this.controller, required this.userId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final selectedGender = ref.watch(selectedGenderProvider);
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Please Enter Your Details", fontSize: 13.sp),
              CustomText(
                  text: "Tell Us About Yourself",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
              CustomText(
                text: "This helps us personalize your fitness experience.",
                fontSize: 10.sp,
                overflow: TextOverflow.visible,
                color: AppThemes.darkTheme.dividerColor,
              ),
             sh20,
          
              // TextField for User Name
              CustomTextField(
                onChanged: (value) {
                  ref.read(userNameProvider.notifier).state = value;
                },
                labelText:"Enter Your Name" ,hintText:"Enter Your Name" ,
          
              ),
          
             sh20,
          
              // Gender Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderOption(label: "Female", image: "assets/images/female.png"),
                  GenderOption(label: "Male", image: "assets/images/male.png"),
                  GenderOption(label: "Other", image: "assets/images/other.png"),
                ],
              ),
          
            
          SizedBox(height: MediaQuery.of(context).size.height/2.33,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                  backgroundColor: AppThemes.darkTheme.primaryColor,
                  textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                  text: "Next",
                  onPressed: () async {
                    if (userName != null && userName.isNotEmpty && selectedGender != null) {
                    viewModel.updateGender(selectedGender,userName);

                      controller?.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter your name and select a gender")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenderOption extends ConsumerWidget {
  final String label;
  final String image;

  GenderOption({required this.label, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(selectedGenderProvider);
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
          color: isSelected
              ? Colors.grey.withOpacity(0.5)
              : AppThemes.darkTheme.appBarTheme.foregroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 35.h, width: 35.w),
            SizedBox(height: 10),
            CustomText(
                text: label, color: AppThemes.darkTheme.dialogBackgroundColor),
          ],
        ),
      ),
    );
  }
}
