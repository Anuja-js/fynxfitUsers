import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingViewModel extends StateNotifier<int> {
  OnboardingViewModel() : super(0);

  void nextPage() {
    if (state < 4) state++;
  }

  void previousPage() {
    if (state > 0) state--;
  }

  void updatePage(int index) {
    state = index;
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingViewModel, int>(
      (ref) => OnboardingViewModel(),
);
