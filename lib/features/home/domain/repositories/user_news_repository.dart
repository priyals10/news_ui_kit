import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';

abstract class UserNewsRepository {
  Future<void> createUserNews(UserNewsModel news);
  Future<void> updateUserNews(UserNewsModel news);
  Future<void> deleteUserNews(String id);
  Future<List<UserNewsModel>> getUserNews(String uid);
  Stream<List<UserNewsModel>> getUserNewsStream(String uid);
}

class CreateUserNewsUseCase {
  final UserNewsRepository repository;
  CreateUserNewsUseCase(this.repository);
  Future<void> call(UserNewsModel news) => repository.createUserNews(news);
}

class UpdateUserNewsUseCase {
  final UserNewsRepository repository;
  UpdateUserNewsUseCase(this.repository);
  Future<void> call(UserNewsModel news) => repository.updateUserNews(news);
}

class DeleteUserNewsUseCase {
  final UserNewsRepository repository;
  DeleteUserNewsUseCase(this.repository);
  Future<void> call(String id) => repository.deleteUserNews(id);
}

class GetUserNewsUseCase {
  final UserNewsRepository repository;
  GetUserNewsUseCase(this.repository);
  Future<List<UserNewsModel>> call(String uid) => repository.getUserNews(uid);
}
