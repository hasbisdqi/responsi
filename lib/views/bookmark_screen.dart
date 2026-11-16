import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsi/controllers/article_controller.dart';
import 'package:responsi/controllers/bookmark_controller.dart';
import 'package:responsi/models/article.dart';
import 'package:responsi/views/detail_screen.dart';
import 'package:responsi/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final ArticleController controller = Get.find<ArticleController>();
  final BookmarkController bookmarkController = Get.find<BookmarkController>();

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', false);
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmark"),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: Obx(() {
        final bookmarks = controller.articles
            .where((article) => bookmarkController.isBookmark(article.id))
            .toList();
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookmarks.isEmpty) {
          return Center(child: Text("Belum ada bookmark!"));
        }

        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final Article article = bookmarks[index];
            return Dismissible(
              background: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete_outline, color: Colors.red),
              ),
              key: Key(article.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                bookmarkController.toggleBookmark(article.id);
              },
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(article: article),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Image.network(article.imageUrl),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              article.title,
                              style: TextStyle(
                                fontWeight: FontWeight(500),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(article.newsSite),
                              Text(article.publishedAt),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
