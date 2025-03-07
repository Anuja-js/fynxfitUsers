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
