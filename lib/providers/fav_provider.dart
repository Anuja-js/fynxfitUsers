import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/services/firestore_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final favoriteStatusProvider = FutureProvider.family<bool, String>((ref, articleId) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final userId = FirebaseAuth.instance.currentUser?.uid; // Replace with the actual user ID
  return await firestoreService.isFavorite(userId!, articleId);
});

