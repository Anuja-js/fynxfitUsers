import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/article_provider.dart';
import '../../widgets/articles.dart';

class ArticleListPage extends ConsumerWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      body: articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(
                  title: articles[index].title,
                  subtitle: articles[index].subtitle,
                  imageUrl: articles[index].imageUrl,
                userId:   articles[index].userId,
                  articleId: articles[index].documentId,

                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(articleProvider.notifier).fetchArticles(); // Fetch articles
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
