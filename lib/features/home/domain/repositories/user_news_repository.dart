import '../entities/user_news.dart';

abstract class UserNewsRepository {
  Future<void> createUserNews(UserNews news);
  Future<void> updateUserNews(UserNews news);
  Future<void> deleteUserNews(String id);
  Future<List<UserNews>> getUserNews(String uid);
  Stream<List<UserNews>> getUserNewsStream(String uid);
}
