import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coach_model.dart';

class CoachRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CoachModel>> fetchCoaches() async {
    try {
      final snapshot = await _firestore.collection('coaches').get();
      return snapshot.docs.map((doc) => CoachModel.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception("Error fetching coaches: $e");
    }
  }
}
