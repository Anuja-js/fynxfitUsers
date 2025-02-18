import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordVisibilityProvider = StateNotifierProvider<PasswordVisibilityViewModel, bool>((ref) {
  return PasswordVisibilityViewModel();
});
class PasswordVisibilityViewModel extends StateNotifier<bool> {
  PasswordVisibilityViewModel() : super(false);

  void togglePasswordVisibility() {
    state = !state;
  }
}