import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsi/controllers/bookmark_controller.dart';
import 'package:responsi/models/article.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final BookmarkController bookmarkController =
        Get.find<BookmarkController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          Obx(() {
            final isBookmark = bookmarkController.isBookmark(article.id);

            return SizedBox(
              child: IconButton(
                onPressed: () async {
                  final wasFavorite = bookmarkController.isBookmark(article.id);

                  await bookmarkController.toggleBookmark(article.id);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        backgroundColor: !wasFavorite
                            ? Colors.green
                            : Colors.grey,
                        content: Text(
                          wasFavorite
                              ? 'Removed from favorites'
                              : 'Added to favorites',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
                icon: Icon(isBookmark ? Icons.bookmark : Icons.bookmark_border),
                color: isBookmark ? Colors.amber : Colors.grey,
              ),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            Image.network(article.imageUrl),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Text(
                article.title,
                style: TextStyle(fontWeight: FontWeight(500), fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(article.newsSite), Text(article.publishedAt)],
            ),
            Column(
              children: article.authors.map((author) {
                return Text(author['name']);
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(article.url);
                // await (uri);
              },
              child: Text("Buka url"),
            ),
          ],
        ),
      ),
    );
  }
}
