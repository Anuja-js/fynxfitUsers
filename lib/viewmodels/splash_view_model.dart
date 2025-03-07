import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
class SplashViewModel extends StateNotifier<bool> {
  SplashViewModel() : super(false) {
    startSplash();
  }
  void startSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    state = true;
  }
}

final splashProvider = StateNotifierProvider<SplashViewModel, bool>(
      (ref) => SplashViewModel(),
);
