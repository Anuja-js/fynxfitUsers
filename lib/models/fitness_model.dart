class FitnessGoal {
  final String title;
  final String imageUrl;

  FitnessGoal({required this.title, required this.imageUrl});

  factory FitnessGoal.fromMap(Map<String, dynamic> data) {
    return FitnessGoal(
      title: data["title"] ?? "Untitled",
      imageUrl: data["imageUrl"] ?? "",
    );
  }
}
