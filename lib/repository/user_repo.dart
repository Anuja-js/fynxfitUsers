import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add or update user in Firestore
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }
  Future<void> update(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }
  // Fetch users from Firestore
  Stream<List<UserModel>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    });
  }
}
