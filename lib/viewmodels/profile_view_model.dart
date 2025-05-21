import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/providers/profile_provider.dart';
import 'package:fynxfituser/repository/profile_repo.dart';
import 'package:fynxfituser/viewmodels/auth_view_model.dart';
import "package:http/http.dart" as http;
import 'package:fynxfituser/models/profile_state.dart';
import 'package:fynxfituser/repository/user_repo.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
  (ref) => ProfileViewModel(),
);

class ProfileViewModel extends StateNotifier<ProfileState> {
  final UserRepository userRepository = UserRepository();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ProfileViewModel() : super(ProfileState());

  void updateGender(String gender,String name) => state = state.copyWith(gender: gender,name:name);

  Future<void> saveGenderToFirestore(String userId) async {
    final user = UserModel(uid: userId, gender: state.gender,name:state.name);
    await userRepository.update(user);
    // await userRepository.addUser(user);
  }

  void updateBirthday(DateTime birthday) {
    state = state.copyWith(birthday: birthday);
  }

  void updateFitnessGoal(List<String> fitnessGoal) {
    state = state.copyWith(fitnessGoal: fitnessGoal.toString());
  }

  Future<void> uploadProfileImage(String imageurl) async {
    state = state.copyWith(profileImageUrl: imageurl.toString());
  }

  Future<void> saveProfileData(String userId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'gender': state.gender,
        'birthday': state.birthday?.toIso8601String(),
        'weight': state.weight,
        'height': state.height,
        "name":state.name,
        'fitnessGoal': state.fitnessGoal,
        'profileImageUrl': state.profileImageUrl,
        'completeProfileOnboarding':true,
        "subscribe":false,
      });
    } catch (e) {
      print("Error saving profile data: $e");
    }
  }

  void updateHeight(double height) {
    state = state.copyWith(height: height);
  }

  void updateweight(double weight) {
    state = state.copyWith(height: weight);
  }

  Future<void> saveHeightToFirestore(String userId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'height': state.height,
      });
    } catch (e) {
      print("Error updating height: $e");
    }
  }

  Future<UserModel?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        var data = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        state = state.copyWith(
          gender: data.gender,
          height: double.tryParse(data.height.toString()),
          weight: double.tryParse(data.weight.toString()),
          profileImageUrl: data.image,
          birthday: DateTime.tryParse(data.age.toString()),
          name: data.name,
          // subcribe:data.subscribe,
        );
        // return
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }
}

final profileImageViewModelProvider =
    StateNotifierProvider<ProfileImageViewModel, AsyncValue<File?>>((ref) {
  return ProfileImageViewModel(ref.read(profileImageRepositoryProvider));
});

class ProfileImageViewModel extends StateNotifier<AsyncValue<File?>> {
  final ProfileImageRepository _repository;
  ProfileImageViewModel(this._repository) : super(const AsyncValue.data(null));

  final ImagePicker _picker = ImagePicker();

  /// **Pick Image from Gallery**
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = AsyncValue.data(File(pickedFile.path));
    }
  }

  /// **Upload Image to Cloudinary & Firestore**
  Future<String?> uploadImage() async {
    if (state.value == null) return "";

    try {
      String? imageUrl =
          await _repository.uploadImageToCloudinary(state.value!);
      return imageUrl!;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
