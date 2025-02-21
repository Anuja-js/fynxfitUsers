import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
      (ref) => ProfileViewModel(),
);

class ProfileState {
  final String gender;
  final DateTime? birthday;
  final double weight;
  final double height;
  final String fitnessGoal;
  final String profileImageUrl;

  ProfileState({
    this.gender = "",
    this.birthday,
    this.weight = 75,
    this.height = 165,
    this.fitnessGoal = "",
    this.profileImageUrl = "",
  });

  ProfileState copyWith({
    String? gender,
    DateTime? birthday,
    double? weight,
    double? height,
    String? fitnessGoal,
    String? profileImageUrl,
  }) {
    return ProfileState(
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

/// ViewModel
class ProfileViewModel extends StateNotifier<ProfileState> {
  ProfileViewModel() : super(ProfileState());

  void updateGender(String gender) => state = state.copyWith(gender: gender);
  void updateBirthday(DateTime birthday) => state = state.copyWith(birthday: birthday);
  void updateWeight(double weight) => state = state.copyWith(weight: weight);
  void updateHeight(double height) => state = state.copyWith(height: height);
  void updateFitnessGoal(String goal) => state = state.copyWith(fitnessGoal: goal);

  Future<void> uploadProfileImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('profile_images/${DateTime.now()}.jpg');
    await storageRef.putFile(imageFile);
    final downloadUrl = await storageRef.getDownloadURL();
    state = state.copyWith(profileImageUrl: downloadUrl);
  }
}

