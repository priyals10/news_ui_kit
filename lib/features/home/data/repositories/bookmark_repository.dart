import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/home/domain/repositories/bookmark_repository.dart' as domain;

class BookmarkRepository implements domain.BookmarkRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  /// Unique key for each article to prevent duplicates in bookmarks.
  String _getArticleId(NewsArticle article) {
    if (article.url.isNotEmpty) {
      // Use base64 to create a safe, unique filename/docID from URL
      return base64Url.encode(utf8.encode(article.url));
    }
    if (article.sourceId.isNotEmpty) return article.sourceId;
    return article.title.hashCode.toString(); // Fallback
  }

  @override
  Future<void> addBookmark(NewsArticle article) async {
    final uid = _userId;
    if (uid == null) return;

    final docId = "${uid}_${_getArticleId(article)}";
    final data = article.toJson();
    data['userId'] = uid; // Add userId for easier top-level tracking

    await _firestore
        .collection('bookmark')
        .doc(docId)
        .set(data);
  }

  @override
  Future<void> removeBookmark(NewsArticle article) async {
    final uid = _userId;
    if (uid == null) return;

    final docId = "${uid}_${_getArticleId(article)}";
    await _firestore
        .collection('bookmark')
        .doc(docId)
        .delete();
  }

  @override
  Future<bool> isBookmarked(NewsArticle article) async {
    final uid = _userId;
    if (uid == null) return false;

    final docId = "${uid}_${_getArticleId(article)}";
    final doc = await _firestore
        .collection('bookmark')
        .doc(docId)
        .get();
        
    return doc.exists;
  }

  @override
  Future<List<NewsArticle>> getBookmarks() async {
    final uid = _userId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('bookmark')
        .where('userId', isEqualTo: uid)
        .get();

    return snapshot.docs
        .map((doc) => NewsArticle.fromJson(doc.data()))
        .toList();
  }

  @override
  Stream<List<NewsArticle>> getBookmarksStream() {
    final uid = _userId;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('bookmark')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NewsArticle.fromJson(doc.data()))
            .toList());
  }
}
