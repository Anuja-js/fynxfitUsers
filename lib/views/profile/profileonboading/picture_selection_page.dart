import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/views/home/main_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fynxfituser/viewmodels/profile_view_model.dart';

import '../../../core/utils/constants.dart';
import '../../../theme.dart';
import '../../../widgets/customs/custom_elevated_button.dart';
import '../../../widgets/customs/custom_text.dart';

class ProfileImage extends ConsumerStatefulWidget {
  const ProfileImage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends ConsumerState<ProfileImage> {
  XFile? imageFile;
  @override
  Widget build(BuildContext context) {
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
                child: imageFile == null
                    ? Stack(
                        children: [
                          CircleAvatar(
                              radius: 70.r,
                              backgroundColor: AppThemes.darkTheme.primaryColor,
                              backgroundImage: profileState
                                      .profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileState.profileImageUrl)
                                  : const AssetImage("assets/images/logo_white.png")),
                          Positioned(
                            bottom: 30,
                            right: 0,
                            child: GestureDetector(
                              onTap: () =>
                                  showImagePicker(context, profileViewModel),
                              child: CircleAvatar(
                                radius: 11.r,
                                backgroundColor: AppThemes
                                    .darkTheme.appBarTheme.foregroundColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppThemes
                                      .darkTheme.scaffoldBackgroundColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Container(
                            width: 140.w,
                            height: 140.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: AppThemes.darkTheme.primaryColor,
                                width: 2, // Adjust thickness
                              ),
                              image: DecorationImage(
                                image: FileImage(File(imageFile!.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            right: 0,
                            child: GestureDetector(
                              onTap: () =>
                                  showImagePicker(context, profileViewModel),
                              child: CircleAvatar(
                                radius: 11.r,
                                backgroundColor: AppThemes
                                    .darkTheme.appBarTheme.foregroundColor,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppThemes
                                      .darkTheme.scaffoldBackgroundColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (imageFile == null)
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomElevatedButton(
                      backgroundColor: AppThemes.darkTheme.primaryColor,
                      textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                      text: "Add a Photo",
                      onPressed: () =>
                          showImagePicker(context, profileViewModel),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MainScreen();
                        }));
                      },
                    ),
                  ),
                ],
              ),
            if (imageFile != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                  backgroundColor:
                      AppThemes.darkTheme.appBarTheme.foregroundColor!,
                  textColor: AppThemes.darkTheme.dividerColor,
                  text: "Next",
                  onPressed: () {
                    final auth=FirebaseAuth.instance.currentUser;
                    profileViewModel.saveProfileData(auth!.uid);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return MainScreen();
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
      backgroundColor:
          AppThemes.darkTheme.scaffoldBackgroundColor.withOpacity(0.7),
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
                onTap: () async {
                  Navigator.pop(context);
                  imageFile = await pickImage(ImageSource.camera, viewModel);
                  setState(() {});
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.image, color: AppThemes.darkTheme.primaryColor),
                title: CustomText(
                  text: "Choose from Gallery",
                  color: AppThemes.darkTheme.scaffoldBackgroundColor,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  imageFile = await pickImage(ImageSource.gallery, viewModel);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<XFile?> pickImage(
      ImageSource source, ProfileViewModel viewModel) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      viewModel.uploadProfileImage(File(pickedFile.path));
    }
    return pickedFile;
  }
}
