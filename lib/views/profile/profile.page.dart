import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/views/profile/privacy/privacy_policy.dart';
import 'package:fynxfituser/views/profile/transactions/transactions_history_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/constants.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../widgets/customs/custom_text.dart';

class ProfileScreen extends ConsumerWidget {
  XFile? imageFile;
   ProfileScreen({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileViewModel = ref.read(profileViewModelProvider.notifier);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomText(
                  text: "Your Fitness Profile",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                sh10,
                Stack(
                  children: [
                    if(imageFile!=null)Image.file(File(imageFile!.path.toString())),
                    if(imageFile==null) CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        backgroundImage:
                             NetworkImage(profileState.profileImageUrl)),
                    Positioned(
                      bottom: 30,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => showImagePicker(context, profileViewModel),
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
                sh10,
                CustomText(
                  text: profileState.name,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text:profileState.birthday.toString(),
                  fontSize: 14,
                ),
                CustomText(
                    text: 'anujas2002@gmail.com',
                    fontSize: 14,
                    color: AppThemes.darkTheme.dividerColor),
                sh20,
                Container(
                  decoration: BoxDecoration(
                      color: Colors.purple.shade400,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildStatItem('${profileState.weight} Kg', 'Weight'),
                      buildStatItem('22', 'Years old'),
                      buildStatItem('${profileState.height} CM', 'Height'),
                      buildStatItem('25', 'BMI'),
                    ],
                  ),
                ),
                buildCustomListTile("Profile", Icons.person,
                    onLeadingPress: () {}, onTrailingPress: () {}),
                buildCustomListTile("Favorite", Icons.favorite,
                    onLeadingPress: () {}, onTrailingPress: () {}),
                buildCustomListTile("Privacy Policy", Icons.lock,
                    onLeadingPress: () {}, onTrailingPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext ctx) {
                    return PrivacyPolicyPage();
                  }));
                }),
                buildCustomListTile("Transactions", Icons.monetization_on,
                    onLeadingPress: () {}, onTrailingPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext ctx) {
                    return TransactionHistoryPage();
                  }));
                }),
                buildCustomListTile("Settings", Icons.settings,
                    onLeadingPress: () {}, onTrailingPress: () {}),
                buildCustomListTile("Help", Icons.help,
                    onLeadingPress: () {}, onTrailingPress: () {}),
                buildCustomListTile(
                  "Logout",
                  Icons.logout_rounded,
                  onLeadingPress: () {},
                  onTrailingPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomListTile(String title, IconData leadingIcon,
      {void Function()? onLeadingPress, void Function()? onTrailingPress}) {
    return ListTile(
      trailing: IconButton(
        onPressed: onTrailingPress ?? () {},
        icon: Icon(
          Icons.chevron_right,
          color: AppThemes.darkTheme.dividerColor,
        ),
      ),
      title: CustomText(
        text: title,
        fontSize: 16,
      ),
      leading: GestureDetector(
        onTap: onLeadingPress,
        child: Container(
          width: 30.w,
          height: 30.h,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            leadingIcon,
            color: AppThemes.darkTheme.appBarTheme.foregroundColor,
            size: 20,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                  // imageFile=await pickImage(ImageSource.camera, viewModel);
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
                  // imageFile=await pickImage(ImageSource.gallery, viewModel);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildStatItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
