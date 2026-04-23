import '../entities/user_news.dart';
import '../repositories/user_news_repository.dart';

class CreateUserNewsUseCase {
  final UserNewsRepository repository;
  CreateUserNewsUseCase(this.repository);
  Future<void> call(UserNews news) => repository.createUserNews(news);
}

class UpdateUserNewsUseCase {
  final UserNewsRepository repository;
  UpdateUserNewsUseCase(this.repository);
  Future<void> call(UserNews news) => repository.updateUserNews(news);
}

class DeleteUserNewsUseCase {
  final UserNewsRepository repository;
  DeleteUserNewsUseCase(this.repository);
  Future<void> call(String id) => repository.deleteUserNews(id);
}

class GetUserNewsUseCase {
  final UserNewsRepository repository;
  GetUserNewsUseCase(this.repository);
  Future<List<UserNews>> call(String uid) => repository.getUserNews(uid);
}
