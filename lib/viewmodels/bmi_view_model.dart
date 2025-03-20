import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bmi_model.dart';

class BMIViewModel extends StateNotifier<BMIModel> {
  BMIViewModel()
      : super(BMIModel(
    height: 0,
    weight: 0,
    bmi: 0,
    isHeightInInches: false,
    isWeightInLbs: false,
  ));

  void toggleHeightUnit() {
    state = state.copyWith(isHeightInInches: !state.isHeightInInches);
  }

  void toggleWeightUnit() {
    state = state.copyWith(isWeightInLbs: !state.isWeightInLbs);
  }

  void calculateBMI(double height, double weight) {
    final updatedBMI = BMIModel.calculate(height, weight, state.isHeightInInches, state.isWeightInLbs);
    state = updatedBMI;
  }
}

final bmiProvider = StateNotifierProvider<BMIViewModel, BMIModel>(
      (ref) => BMIViewModel(),
);
