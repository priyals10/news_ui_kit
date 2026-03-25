import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/domain/repositories/user_news_repository.dart' as domain;

class UserNewsRepository implements domain.UserNewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createUserNews(UserNewsModel news) async {
    await _firestore.collection('user_news').doc(news.id).set(news.toJson());
  }

  @override
  Future<void> updateUserNews(UserNewsModel news) async {
    await _firestore.collection('user_news').doc(news.id).update(news.toJson());
  }

  @override
  Future<void> deleteUserNews(String id) async {
    if (id.isEmpty) return;
    await _firestore.collection('user_news').doc(id).delete();
  }

  @override
  Future<List<UserNewsModel>> getUserNews(String uid) async {
    final snapshot = await _firestore
        .collection('user_news')
        .where('authorId', isEqualTo: uid)
        .get();
        
    final List<UserNewsModel> newsList = snapshot.docs
        .map((doc) => UserNewsModel.fromJson(doc.data()))
        .toList();
        
    newsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return newsList;
  }

  @override
  Stream<List<UserNewsModel>> getUserNewsStream(String uid) {
    return _firestore
        .collection('user_news')
        .where('authorId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final List<UserNewsModel> newsList = snapshot.docs
          .map((doc) => UserNewsModel.fromJson(doc.data()))
          .toList();
      newsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return newsList;
    });
  }
}
