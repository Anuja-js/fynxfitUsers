import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/fitness_model.dart';

class FitnessGoalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FitnessGoal>> fetchFitnessGoals() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("category").get();
      return snapshot.docs.map((doc) => FitnessGoal.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception("Failed to fetch fitness goals: $e");
    }
  }
}
