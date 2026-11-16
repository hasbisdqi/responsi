class Article {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String publishedAt;
  final List<dynamic> authors;
  final String summary;

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.publishedAt,
    required this.authors,
    required this.summary,
  });

  factory Article.fromJson(Map<String, dynamic> jsonData) {
    return Article(
      id: jsonData['id'],
      title: jsonData['title'],
      url: jsonData['url'],
      imageUrl: jsonData['image_url'],
      newsSite: jsonData['news_site'],
      publishedAt: jsonData['published_at'],
      authors: jsonData['authors'],
      summary: jsonData['summary'],
    );
  }
}
