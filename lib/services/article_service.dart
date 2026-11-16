import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:responsi/models/article.dart';

class ArticleService {
  final Uri _url = Uri.parse(
    "https://api.spaceflightnewsapi.net/v4/articles/?format=json",
  );

  Future<List<Article>> fetchArticle() async {
    final response = await http.get(_url);
    final result = jsonDecode(response.body);

    final List<dynamic> articles = result['results'];

    return articles.map((char) => Article.fromJson(char)).toList();
  }
}
