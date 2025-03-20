import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/repository/coaches_repo.dart';
import '../models/coach_model.dart';

final coachRepositoryProvider = Provider((ref) => CoachRepository());

final coachListProvider = FutureProvider<List<CoachModel>>((ref) async {
  final repository = ref.read(coachRepositoryProvider);
  return repository.fetchCoaches();
});
