import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  int? age;
  String? gender;
  String? email;
  String? displayName;
  String? weight;
  String? height;
  List<String>? fitnessGoals;
  String? image;
  String? createdAt;

  UserModel({
    required this.uid,
    this.age,
    this.gender,
    this.email,
    this.displayName,
    this.weight,
    this.height,
    this.fitnessGoals,
    this.image,
    this.createdAt,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'age': age,
      'gender': gender,
      'email': email,
      'displayName': displayName,
      'weight': weight,
      'height': height,
      'fitnessGoals': fitnessGoals,
      'image': image,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create model from Firestore snapshot
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      weight: json['weight'] as String?,
      height: json['height'] as String?,
      fitnessGoals: (json['fitnessGoals'] as List<dynamic>?)
          ?.map((goal) => goal as String)
          .toList(),
      image: json['image'] as String?,
      createdAt: json['createdAt']?.toString(),
    );
  }
}
