import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article_model.dart';

class ArticleNotifier extends StateNotifier<List<ArticleModel>> {
  ArticleNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch articles from Firestore
  Future<void> fetchArticles() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Articles")
          .orderBy('createdAt', descending: true)
          .get();

      List<ArticleModel> articles = snapshot.docs.map((doc) {
        return ArticleModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("Fetched ${articles.length} articles.");
      state = articles;
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  void searchArticles(String query) {
    final lowerQuery = query.toLowerCase();
   state= state.where((article) {
      final title = article.title.toLowerCase();
      final content = article.subtitle.toLowerCase();
      return title.contains(lowerQuery) || content.contains(lowerQuery);
    }).toList();
  }

}

final articleProvider =
StateNotifierProvider<ArticleNotifier, List<ArticleModel>>(
        (ref) => ArticleNotifier());
