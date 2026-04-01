import 'package:isar/isar.dart';
import 'package:news_ui_kit/features/home/data/models/local_news.dart';

class UserNewsLocalDataSource {
  final Isar isar;

  UserNewsLocalDataSource(this.isar);

  /// Gets news articles from the local database
  Future<List<LocalNews>> getUserNews(String uid) async {
    return await isar.localNews
        .filter()
        .authorIdEqualTo(uid)
        .sortByCreatedAtDesc()
        .findAll();
  }

  /// Streams news articles from the local database
  Stream<List<LocalNews>> watchUserNews(String uid) {
    return isar.localNews
        .filter()
        .authorIdEqualTo(uid)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  /// Caches a list of news articles from the cloud to the disk
  Future<void> cacheUserNews(List<LocalNews> news) async {
    await isar.writeTxn(() async {
      await isar.localNews.putAll(news);
    });
  }

  /// Saves a single news article to the disk
  Future<void> saveUserNews(LocalNews news) async {
    await isar.writeTxn(() async {
      await isar.localNews.put(news);
    });
  }

  /// Deletes a news article from the disk using its Firestore ID
  Future<void> deleteUserNews(String firestoreId) async {
    await isar.writeTxn(() async {
      await isar.localNews.filter().firestoreIdEqualTo(firestoreId).deleteAll();
    });
  }

  /// Finds articles saved while the user was offline
  Future<List<LocalNews>> getUnsyncedNews() async {
    return await isar.localNews.filter().isSyncedEqualTo(false).findAll();
  }

  /// Searches news articles locally using Full-Text Search on the title
  Future<List<LocalNews>> searchUserNews(String query) async {
    return await isar.localNews
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .contentContains(query, caseSensitive: false)
        .sortByCreatedAtDesc()
        .findAll();
  }
}
