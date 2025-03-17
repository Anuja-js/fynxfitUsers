import 'package:flutter/material.dart';
import '../views/article/article_detail_screen.dart';


class ArticleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const ArticleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ArticleDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(
              title: title,
              subtitle: subtitle,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        child: Column(
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ListTile(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
