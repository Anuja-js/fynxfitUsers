class BMIModel {
  final double height;
  final double weight;
  final double bmi;
  final bool isHeightInInches;
  final bool isWeightInLbs;

  BMIModel({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.isHeightInInches,
    required this.isWeightInLbs,
  });

  factory BMIModel.calculate(double height, double weight, bool isHeightInInches, bool isWeightInLbs) {
    double heightCm = isHeightInInches ? height * 2.54 : height;
    double weightKg = isWeightInLbs ? weight * 0.453592 : weight;
    double bmiValue = weightKg / ((heightCm / 100) * (heightCm / 100));

    return BMIModel(
      height: heightCm,
      weight: weightKg,
      bmi: bmiValue,
      isHeightInInches: isHeightInInches,
      isWeightInLbs: isWeightInLbs,
    );
  }

  String getCategory() {
    if (bmi < 18.5) return "Underweight";
    if (bmi >= 18.5 && bmi < 24.9) return "Normal Weight";
    if (bmi >= 25 && bmi < 29.9) return "Overweight";
    return "Obese";
  }

  BMIModel copyWith({
    double? height,
    double? weight,
    double? bmi,
    bool? isHeightInInches,
    bool? isWeightInLbs,
  }) {
    return BMIModel(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      isHeightInInches: isHeightInInches ?? this.isHeightInInches,
      isWeightInLbs: isWeightInLbs ?? this.isWeightInLbs,
    );
  }
}
