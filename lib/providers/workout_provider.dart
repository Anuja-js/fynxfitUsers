import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';

class WorkoutNotifier extends StateNotifier<List<WorkoutModel>> {
  WorkoutNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchWorkouts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("workouts")
          .orderBy('createdAt', descending: true)
          .get();

      List<WorkoutModel> workouts = snapshot.docs.map((doc) {
        return WorkoutModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Fetched ${workouts.length} workouts.");
      state = workouts;
    } catch (e) {
      print("Error fetching workouts: $e");
    }
  }

  sort(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("workouts")
          .where('category', isEqualTo: category)
          .get();

      List<WorkoutModel> workouts = snapshot.docs.map((doc) {
        return WorkoutModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Fetched ${workouts.length} workouts for category: $category");
      state = workouts;
    } catch (e) {
      print("Error fetching workouts: $e");
      state=[];
    }
  }
  void searchWorkouts(String query) {
    final lowerQuery = query.toLowerCase();

    state = state.where((workout) {
      final name = workout.title.toLowerCase();
      final description = workout.description.toLowerCase();
      return name.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();
  }

}

// Provider for fetching workouts
final workoutProvider =
StateNotifierProvider<WorkoutNotifier, List<WorkoutModel>>(
        (ref) => WorkoutNotifier());
