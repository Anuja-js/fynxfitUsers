import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/views/profile/profile.page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fynxfituser/viewmodels/profile_view_model.dart';

import '../../../core/utils/constants.dart';
import '../../../theme.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text.dart';

class ProfileImage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileViewModel = ref.read(profileViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Set Up Your Profile Picture,\nAnuja!",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.visible,
            ),
            CustomText(
              text: "A picture helps personalize your\nfitness journey.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                        radius: 70.r,
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        backgroundImage: profileState.profileImageUrl.isNotEmpty
                            ? NetworkImage(profileState.profileImageUrl)
                            : AssetImage("assets/images/logo_white.png")),
                    Positioned(
                      bottom: 30,
                      right: 0,
                      child: GestureDetector(
                        onTap: () =>
                            showImagePicker(context, profileViewModel),
                        child: CircleAvatar(
                          radius: 11.r,
                          backgroundColor:
                              AppThemes.darkTheme.appBarTheme.foregroundColor,
                          child: Icon(
                            Icons.camera_alt,
                            color: AppThemes.darkTheme.scaffoldBackgroundColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text: "Add a Photo",
                onPressed: () => showImagePicker(context, profileViewModel),
              ),
            ),
            sh10,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor:
                    AppThemes.darkTheme.appBarTheme.foregroundColor!,
                textColor: AppThemes.darkTheme.dividerColor,
                text: "Skip",
                onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return ProfileScreen();
              }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImagePicker(BuildContext context, ProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor:AppThemes.darkTheme.scaffoldBackgroundColor.withOpacity(0.7),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          height: 200.h,
          decoration: BoxDecoration(
            color: AppThemes.darkTheme.appBarTheme.foregroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    Icon(Icons.camera, color: AppThemes.darkTheme.primaryColor),
                title: CustomText(
                  text: "Take a Photo",
                  color: AppThemes.darkTheme.scaffoldBackgroundColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera, viewModel);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.image, color: AppThemes.darkTheme.primaryColor),
                title: CustomText(
                  text: "Choose from Gallery",
                  color: AppThemes.darkTheme.scaffoldBackgroundColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery, viewModel);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(
      ImageSource source, ProfileViewModel viewModel) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      viewModel.uploadProfileImage(File(pickedFile.path));
    }
  }
}
