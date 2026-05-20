import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';

class UserNewsRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches news articles from Firestore
  Future<List<UserNewsModel>> getUserNews(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('user_news')
          .where('authorId', isEqualTo: uid)
          .get();
          
      return snapshot.docs
          .map((doc) => UserNewsModel.fromJson(doc.data()))
          .toList();
    } catch (_) {
      try {
        final cacheSnap = await _firestore
            .collection('user_news')
            .where('authorId', isEqualTo: uid)
            .get(const GetOptions(source: Source.cache));
            
        return cacheSnap.docs
            .map((doc) => UserNewsModel.fromJson(doc.data()))
            .toList();
      } catch (_) {}
    }
    return [];
  }

  /// Uploads a new article to Firestore
  Future<void> createUserNews(UserNewsModel news) async {
    await _firestore.collection('user_news').doc(news.id).set(news.toJson());
  }

  /// Updates an article in Firestore
  Future<void> updateUserNews(UserNewsModel news) async {
    await _firestore.collection('user_news').doc(news.id).update(news.toJson());
  }

  /// Deletes an article from Firestore
  Future<void> deleteUserNews(String id) async {
    await _firestore.collection('user_news').doc(id).delete();
  }
}
