import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/fav_provider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  /// 🏷 Toggle a favorite article in "favoriteList"
  Future<void> toggleFavorite(String userId, String documentId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) {
      // Initialize user document if missing
      await userRef.set({'favoriteList': []}, SetOptions(merge: true));
    }

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> favoriteList = userData['favoriteList'] ?? [];

    if (favoriteList.contains(documentId)) {
      await userRef.update({
        'favoriteList': FieldValue.arrayRemove([documentId])
      });
    } else {
      await userRef.update({
        'favoriteList': FieldValue.arrayUnion([documentId])
      });
    }
  }

  /// 🏷 Check if an article is in "favoriteList"
  Future<bool> isFavorite(String userId, String documentId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) return false;

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> favoriteList = userData['favoriteList'] ?? [];
    return favoriteList.contains(documentId);
  }

  /// 🏋️ Toggle a workout in "favoriteWorkouts"
  Future<void> toggleWorkoutFavorite(String userId, String workoutId) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({'favoriteWorkouts': []}, SetOptions(merge: true));
    }

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> favoriteWorkouts = userData['favoriteWorkouts'] ?? [];

    if (favoriteWorkouts.contains(workoutId)) {
      await userRef.update({
        'favoriteWorkouts': FieldValue.arrayRemove([workoutId])
      });
      isFavoriteNotifier.value = false;
    } else {
      await userRef.update({
        'favoriteWorkouts': FieldValue.arrayUnion([workoutId])
      });
      isFavoriteNotifier.value = true;
    }
  }

  /// 🏋️ Check if a workout is in "favoriteWorkouts"
  Future<bool> checkWorkoutFavorite(String userId, String workoutId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    print(".................................................................");
    if (!userDoc.exists)return false;

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> favoriteWorkouts = userData['favoriteWorkouts'] ?? [];

    print(favoriteWorkouts);
    isFavoriteNotifier.value = await favoriteWorkouts.contains(workoutId);
    return favoriteWorkouts.contains(workoutId);
  }

  /// 📰 Fetch favorite articles with details
  Future<List<Map<String, dynamic>>> getFavoriteArticlesWithDetails(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) return [];

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> favoriteList = userData['favoriteList'] ?? [];

    List<Map<String, dynamic>> favoriteArticles = [];

    for (String documentId in favoriteList) {
      DocumentSnapshot articleDoc = await _firestore.collection('Articles').doc(documentId).get();
      if (articleDoc.exists) {
        favoriteArticles.add({'id': documentId, ...articleDoc.data() as Map<String, dynamic>});
      }
    }
    return favoriteArticles;
  }

  /// 🏋️ Fetch favorite workouts with details
  Future<List<Map<String, dynamic>>> getFavoriteWorkoutsWithDetails(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) return [];

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    List<dynamic> favoriteWorkouts = userData['favoriteWorkouts'] ?? [];

    List<Map<String, dynamic>> favoriteWorkoutList = [];

    for (String workoutId in favoriteWorkouts) {
      DocumentSnapshot workoutDoc = await _firestore.collection('workouts').doc(workoutId).get();
      if (workoutDoc.exists) {
        favoriteWorkoutList.add({'id': workoutId, ...workoutDoc.data() as Map<String, dynamic>});
      }
    }
    return favoriteWorkoutList;
  }

}
