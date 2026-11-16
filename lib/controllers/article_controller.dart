import 'package:get/get.dart';
import 'package:responsi/models/article.dart';
import 'package:responsi/services/article_service.dart';

class ArticleController extends GetxController {
  final ArticleService _articleService = ArticleService();

  final RxList<Article> _articles = <Article>[].obs;
  final RxBool _isLoading = false.obs;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    _retrieveData();
    super.onInit();
  }

  Future<void> _retrieveData() async {
    try {
      _isLoading.value = true;
      final data = await _articleService.fetchArticle();
      _articles.assignAll(data);
      _isLoading.value = false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
