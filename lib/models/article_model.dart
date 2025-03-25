import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String documentId;
  final String userId;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime createdAt;
  final String imageId;

  ArticleModel({
    required this.documentId,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.createdAt,required this.imageId
  });

  /// Convert Firestore document to ArticleModel
  factory ArticleModel.fromJson(Map<String, dynamic> json, String docId) {
    return ArticleModel(
      documentId: docId,
      userId: json['userId']?.toString() ?? '', // Ensure it's a string
      imageId: json['imageId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

}
