import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fynxfituser/models/profile_state.dart';

import '../viewmodels/profile_view_model.dart';

final nameControllerProvider = Provider((ref) => TextEditingController());
final emailControllerProvider = Provider((ref) => TextEditingController());
final passwordControllerProvider = Provider((ref) => TextEditingController());
final confirmPasswordControllerProvider = Provider((ref) => TextEditingController());

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
      (ref) => ProfileViewModel(),
);
