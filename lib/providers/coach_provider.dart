import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/repository/coaches_repo.dart';
import '../models/coach_model.dart';

final coachRepositoryProvider = Provider((ref) => CoachRepository(FirebaseFirestore.instance));

final coachListProvider = FutureProvider<List<CoachModel>>((ref) async {
  final repository = ref.read(coachRepositoryProvider);
  return repository.fetchCoaches();
});
