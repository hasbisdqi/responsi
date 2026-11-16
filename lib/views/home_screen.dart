import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsi/controllers/article_controller.dart';
import 'package:responsi/models/article.dart';
import 'package:responsi/views/bookmark_screen.dart';
import 'package:responsi/views/detail_screen.dart';
import 'package:responsi/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ArticleController controller = Get.find<ArticleController>();
  String _loginData = "";

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

  void _getLogin() async {
    final loginData = await SharedPreferences.getInstance();
    setState(() {
      _loginData = loginData.getString("loginData") ?? "";
    });
  }

  @override
  void initState() {
    _getLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loginData),
        actions: [
          IconButton(onPressed: _logout, icon: Icon(Icons.logout)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkScreen()),
              );
            },
            icon: Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Column(

        children: [
          SizedBox(
            height: 800,
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.articles.length,
                itemBuilder: (context, index) {
                  final Article article = controller.articles[index];
                  return GestureDetector(
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
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
