import 'package:fynxfituser/models/coach_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoachRepository {
  final FirebaseFirestore _firestore;

  CoachRepository(this._firestore);

  Future<List<CoachModel>> fetchCoaches() async {
    try {
      final snapshot = await _firestore.collection('coaches').get();

      // Log the number of documents retrieved
      print("Fetched ${snapshot.docs.length} coaches.");

      return snapshot.docs
          .map((doc) => CoachModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)) // Use fromFirestore
          .where((coach) => coach.verified) // Only include verified coaches
          .toList();
    } catch (e) {
      print("Error fetching coaches: $e"); // Log the error
      throw Exception("Failed to fetch coaches: $e");
    }
  }
}
