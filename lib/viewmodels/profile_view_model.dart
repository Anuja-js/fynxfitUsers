import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fynxfituser/models/fitness_model.dart';
import 'package:fynxfituser/models/profile_state.dart';
import 'package:fynxfituser/repository/user_repo.dart';
import '../models/user_model.dart';

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
      (ref) => ProfileViewModel(),
);

class ProfileViewModel extends StateNotifier<ProfileState> {
  final UserRepository _userRepository = UserRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ProfileViewModel() : super(ProfileState());

  void updateGender(String gender) => state = state.copyWith(gender: gender);

  Future<void> saveGenderToFirestore(String userId) async {
    final user = UserModel(uid: userId,  gender: state.gender);
    await _userRepository.update(user);
    // await _userRepository.addUser(user);
  }
  void updateBirthday(DateTime birthday) {
    state = state.copyWith(birthday: birthday);
  }
  void updateFitnessGoal(List<String> fitnessGoal) {
    state = state.copyWith(fitnessGoal: fitnessGoal.toString());
  }
  Future<void> uploadProfileImage(File imageFile) async {
    // Upload logic using Firebase Storage
  }
  Future<void> saveProfileData(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'gender': state.gender,
        'birthday': state.birthday?.toIso8601String(),
        'weight': state.weight,
        'height': state.height,
        'fitnessGoal': state.fitnessGoal,
        'profileImageUrl': state.profileImageUrl,
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
      await _firestore.collection('users').doc(userId).update({
        'height': state.height,
      });
    } catch (e) {
      print("Error updating height: $e");
    }
  }

}


