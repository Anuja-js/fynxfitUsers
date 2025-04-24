import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/theme.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import 'package:fynxfituser/viewmodels/profile_view_model.dart';
import 'package:fynxfituser/views/home/main_screen.dart';
import 'package:fynxfituser/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfituser/widgets/customs/custom_text.dart';

class ProfileImageScreen extends ConsumerWidget {
  const ProfileImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    final imageState = ref.watch(profileImageViewModelProvider);
    final viewModels = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileImageViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "Set Up Your Profile Picture!",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: "A picture helps personalize your fitness journey.",
              fontSize: 10,
              color: Colors.grey,
            ),
            Expanded(
              child: Center(
                child: imageState.when(
                  data: (imageFile) {
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: AppThemes.darkTheme.primaryColor,
                          backgroundImage: imageFile == null
                              ? const AssetImage("assets/images/logo_white.png")
                              : FileImage(imageFile) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 30,
                          right: 0,
                          child: GestureDetector(
                            onTap: viewModel.pickImage,
                            child: CircleAvatar(
                              radius: 11,
                              backgroundColor: Colors.grey,
                              child: const Icon(Icons.camera_alt, size: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => const Text("Failed to load image"),
                ),
              ),
            ),
            if ( imageState.value==null)
              SizedBox(width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                  backgroundColor: AppThemes.darkTheme.primaryColor,
                  textColor: Colors.white,
                  text: "Add a Photo",
                  onPressed: viewModel.pickImage,
                ),
              ),
            const SizedBox(height: 10),
            if ( imageState.value==null)
              SizedBox(width: MediaQuery.of(context).size.width,
                child: CustomElevatedButton(
                  backgroundColor: Colors.grey,
                  textColor: Colors.black,
                  text: "Skip",
                  onPressed: () async{  viewModels.copyWith(profileImageUrl:null );
                  final auth=await FirebaseAuth.instance.currentUser;
                  ref.read(profileViewModelProvider.notifier).saveProfileData(auth!.uid);

                  Navigator.push(context, MaterialPageRoute(builder: (ctx){
                    return MainScreen();
                  }));
                  },
                ),
              ),
            if (imageState.value != null)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomElevatedButton(
                  backgroundColor: AppThemes.darkTheme.primaryColor,
                  textColor: Colors.white,
                  text: "Next",
                  onPressed: () async {
                    ref.read(isLoadingProvider.notifier).state = true;

                    try {
                      String? imageUrl = await viewModel.uploadImage();

                      viewModels.copyWith(profileImageUrl: imageUrl);

                      final auth = await FirebaseAuth.instance.currentUser;
                      if (imageUrl != null) {
                        await ref.read(profileViewModelProvider.notifier).uploadProfileImage(imageUrl);
                      }

                      await ref.read(profileViewModelProvider.notifier).saveProfileData(auth!.uid);

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => MainScreen()),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    } finally {
                      ref.read(isLoadingProvider.notifier).state = false;
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
