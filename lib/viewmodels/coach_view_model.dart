import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/providers/coach_provider.dart';
import '../models/coach_model.dart';
import '../repository/coaches_repo.dart';

class CoachViewModel extends StateNotifier<AsyncValue<List<CoachModel>>> {
  final CoachRepository _repository;

  CoachViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchCoaches();
  }

  Future<void> fetchCoaches() async {
    try {
      final coaches = await _repository.fetchCoaches();
      state = AsyncValue.data(coaches);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final coachViewModelProvider =
StateNotifierProvider<CoachViewModel, AsyncValue<List<CoachModel>>>(
      (ref) => CoachViewModel(ref.read(coachRepositoryProvider)),
);
