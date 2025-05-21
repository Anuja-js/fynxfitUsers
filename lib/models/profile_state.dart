class ProfileState {
  final String gender;
  final DateTime? birthday;
  final double weight;
  final double height;
  final String fitnessGoal;
  final String profileImageUrl;
  final String name;

  ProfileState({
    this.gender = "",
    this.name="",
    this.birthday,
    this.weight = 0,
    this.height = 0,
    this.fitnessGoal = "",
    this.profileImageUrl = "",
  });

  ProfileState copyWith({
    String? gender,
    DateTime? birthday,
    double? weight,
    double? height,
    String? fitnessGoal,
    String? name,
    String? profileImageUrl,
  }) {
    return ProfileState(
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
     name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
