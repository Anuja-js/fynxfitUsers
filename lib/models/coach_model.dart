class CoachModel {
  final String id;
  final String name;
  final String profileImage;
  final String expertise;
  final String experience;
  final String bio;  final bool verified;

  CoachModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.bio,
    required this.expertise,
    required this.experience,
    required this.verified,
  });

  // Convert Firestore document to CoachModel
  factory CoachModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CoachModel(
      id: id,
      name: data['name'] ?? '',
      profileImage: data['profileImage'] ?? '',
      expertise: data['expertise'] ?? '',
    experience: data['experience'] ?? '',
    bio: data['bio'] ?? '',
      verified: data['verified'] ?? false,
    );
  }
}
