import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  final String documentId;
  final String userId;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final DateTime createdAt;

  WorkoutModel({
    required this.documentId,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.createdAt,
  });

  /// Convert Firestore document to WorkoutModel
  factory WorkoutModel.fromJson(Map<String, dynamic> json, String docId) {
    return WorkoutModel(
      documentId: docId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert WorkoutModel to Firestore JSON format
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
