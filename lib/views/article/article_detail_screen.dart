import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fynxfituser/services/firestore_service.dart';

import '../../providers/favorites_provider.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

class ArticleDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String articleId;

  const ArticleDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.articleId,
  });

  @override
  ConsumerState<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends ConsumerState<ArticleDetailPage> {
   String uid="";
   bool isFavorite=false;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    loadFavoriteStatus();
  }
   bool favoriteStatus=false;
  Future<void> loadFavoriteStatus() async {
    final firestoreService = ref.read(firestoreServiceProvider);
   isFavorite = await firestoreService.isFavorite(uid, widget.articleId);
   setState(() {
   });
  }

  Future<void> toggleFavorite() async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.toggleFavorite(FirebaseAuth.instance.currentUser!.uid, widget.articleId);

    ref.read(favoritesProvider(FirebaseAuth.instance.currentUser!.uid).notifier).fetchFavorites();
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = ref.watch(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.imageUrl, fit: BoxFit.cover, width: double.infinity),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.subtitle,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
