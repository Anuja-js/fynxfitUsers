import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String documentId;
  final String userId;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime createdAt;

  ArticleModel({
    required this.documentId,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.createdAt,
  });

  /// Convert Firestore document to ArticleModel
  factory ArticleModel.fromJson(Map<String, dynamic> json, String docId) {
    return ArticleModel(
      documentId: docId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
