import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repository/user_repo.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  // Fetch users from Firestore
  void fetchUsers() {
    _repository.getUsers().listen((users) {
      state = AsyncValue.data(users);
    });
  }

  // Add user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await _repository.addUser(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Riverpod Provider for ViewModel
final userRepositoryProvider = Provider((ref) => UserRepository());
final userProvider =
StateNotifierProvider<UserNotifier, AsyncValue<List<UserModel>>>(
      (ref) => UserNotifier(ref.read(userRepositoryProvider)),
);
