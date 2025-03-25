import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

// FirestoreService Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Notifier for managing favorites
class FavoritesNotifier extends StateNotifier<AsyncValue<Map<String, List<Map<String, dynamic>>>>> {
  final FirestoreService _firestoreService;
  final String userId;

  FavoritesNotifier(this._firestoreService, this.userId)
      : super(const AsyncValue.loading()) {
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    state = const AsyncValue.loading();
    try {
      final articles = await _firestoreService.getFavoriteArticlesWithDetails(userId);
      final workouts = await _firestoreService.getFavoriteWorkoutsWithDetails(userId);

      state = AsyncValue.data({
        'articles': articles,
        'workouts': workouts,
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print("Error fetching favorites: $e");
    }
  }
}

// Favorites Provider using StateNotifier
final favoritesProvider = StateNotifierProvider.family<FavoritesNotifier, AsyncValue<Map<String, List<Map<String, dynamic>>>>, String>(
      (ref, userId) {
    final firestoreService = ref.read(firestoreServiceProvider);
    return FavoritesNotifier(firestoreService, userId);
  },
);
