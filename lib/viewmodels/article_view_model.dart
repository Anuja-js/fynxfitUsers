import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/providers/fav_provider.dart';
import 'package:fynxfituser/services/firestore_service.dart';

class ArticleViewModel extends StateNotifier<Map<String, bool>> {
  final FirestoreService _firestoreService;
  final String userId;

  ArticleViewModel(this._firestoreService, this.userId) : super({});

  Future<void> toggleFavorite(String articleId) async {
    await _firestoreService.toggleFavorite(userId, articleId);
    state = {...state, articleId: !(state[articleId] ?? false)};
  }

  Future<void> loadFavoriteStatus(String articleId) async {
    bool isFav = await _firestoreService.isFavorite(userId, articleId);
    state = {...state, articleId: isFav};
  }

  bool isFavorite(String articleId) {
    return state[articleId] ?? false;
  }
}

final articleViewModelProvider =
StateNotifierProvider.family<ArticleViewModel, Map<String, bool>, String>(
      (ref, userId) => ArticleViewModel(ref.watch(firestoreServiceProvider), userId),
);
