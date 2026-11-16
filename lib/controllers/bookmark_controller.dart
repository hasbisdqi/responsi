import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkController extends GetxController {
  final bookmarkIds = <int>[].obs;

  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    prefs = await SharedPreferences.getInstance();

    final ids = prefs.getStringList('bookmark_ids') ?? [];

    bookmarkIds.assignAll(ids.map((id) => int.parse(id)));
  }

  bool isBookmark(int id) {
    return bookmarkIds.contains(id);
  }

  Future<void> toggleBookmark(int id) async {
    if (isBookmark(id)) {
      bookmarkIds.remove(id);
    } else {
      bookmarkIds.add(id);
    }

    await prefs.setStringList(
      'bookmark_ids',
      bookmarkIds.map((id) => id.toString()).toList(),
    );
  }
}
