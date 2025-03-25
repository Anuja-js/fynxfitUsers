import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  final String documentId;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final DateTime createdAt;
  final String advantages;
  final String intensity;
  final String muscle;
  final String sets;
  final String repetitions;

  WorkoutModel({
    required this.documentId,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.createdAt,
    required this.sets,
    required this.repetitions,
    required this.muscle,
    required this.advantages,
    required this.intensity,
  });

  /// Convert Firestore document to WorkoutModel
  factory WorkoutModel.fromJson(Map<String, dynamic> json, String docId) {
    return WorkoutModel(
      documentId: docId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      sets: json['sets'] ?? '',
      repetitions: json['repetitions'] ?? '',
      muscle: json['muscle'] ?? '',
      advantages: json['advantages'] ?? '',
      intensity: json['intensity'] ?? '',
    );
  }

  /// Convert WorkoutModel to Firestore JSON format
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'subtitle': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'sets': sets,
      'repetitions': repetitions,
      'muscle': muscle,
      'advantages': advantages,
      'intensity': intensity,
    };
  }
}
