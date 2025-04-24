import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final followProvider = ChangeNotifierProvider<FollowNotifier>((ref) {
  return FollowNotifier();
});

class FollowNotifier extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isFollowing(String userId, String coachId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('following')
        .doc(coachId)
        .get();
    return doc.exists;
  }

  Future<void> followCoach(String userId, String coachId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('following')
        .doc(coachId)
        .set({'followedAt': Timestamp.now()});

    await _firestore
        .collection('coaches')
        .doc(coachId)
        .collection('followers')
        .doc(userId)
        .set({'followedAt': Timestamp.now()});
    notifyListeners();
  }

  Future<void> unfollowCoach(String userId, String coachId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('following')
        .doc(coachId)
        .delete();

    await _firestore
        .collection('coaches')
        .doc(coachId)
        .collection('followers')
        .doc(userId)
        .delete();
    notifyListeners();
  }

  Future<int> getFollowersCount(String coachId) async {
    final snap = await _firestore
        .collection('coaches')
        .doc(coachId)
        .collection('followers')
        .get();
    return snap.docs.length;
  }

  Future<int> getFollowingCount(String userId) async {
    final snap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('following')
        .get();
    return snap.docs.length;
  }
}
