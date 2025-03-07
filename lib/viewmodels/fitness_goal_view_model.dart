import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/models/fitness_model.dart';
import 'package:fynxfituser/repository/firestore_goal_repo.dart';

final fitnessGoalViewModelProvider =
StateNotifierProvider<FitnessGoalViewModel, AsyncValue<List<FitnessGoal>>>(
        (ref) => FitnessGoalViewModel(FitnessGoalRepository()));

class FitnessGoalViewModel extends StateNotifier<AsyncValue<List<FitnessGoal>>> {
  final FitnessGoalRepository _repository;

  FitnessGoalViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchGoals();
  }

  Future<void> fetchGoals() async {
    try {
      state = const AsyncValue.loading();
      final goals = await _repository.fetchFitnessGoals();
      state = AsyncValue.data(goals);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
