import 'package:news_ui_kit/core/network_info.dart';
import '../../domain/entities/user_news.dart';
import '../../domain/repositories/user_news_repository.dart' as domain;
import '../data_sources/user_news_local_data_source.dart';
import '../data_sources/user_news_remote_data_source.dart';
import '../models/user_news_model.dart';

class UserNewsRepositoryImpl implements domain.UserNewsRepository {
  final UserNewsLocalDataSource localDataSource;
  final UserNewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserNewsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> createUserNews(UserNews news) async {
    final model = UserNewsModel.fromEntity(news);
    
    // 1. Save to Local DB first (Optimistic UI)
    await localDataSource.saveUserNews(model.toLocal(isSynced: false));

    // 2. Sync to Firestore if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createUserNews(model);
        // Mark as synced if successful
        await localDataSource.saveUserNews(model.toLocal(isSynced: true));
      } catch (_) {
        // If it fails, stays isSynced = false for later retry
      }
    }
  }

  @override
  Future<void> updateUserNews(UserNews news) async {
    final model = UserNewsModel.fromEntity(news);
    await localDataSource.saveUserNews(model.toLocal(isSynced: false));
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUserNews(model);
        await localDataSource.saveUserNews(model.toLocal(isSynced: true));
      } catch (_) {}
    }
  }

  @override
  Future<void> deleteUserNews(String id) async {
    await localDataSource.deleteUserNews(id);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUserNews(id);
      } catch (_) {}
    }
  }

  @override
  Future<List<UserNews>> getUserNews(String uid) async {
    // Return disk data first
    final localList = await localDataSource.getUserNews(uid);
    
    // Background fetch if online
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getUserNews(uid);
        await localDataSource.cacheUserNews(remoteData.map((e) => e.toLocal()).toList());
        return remoteData; // These are UserNewsModel which extends UserNews
      } catch (_) {}
    }
    
    return localList.map((e) => e.toModel()).toList(); // toModel returns UserNewsModel
  }

  @override
  Stream<List<UserNews>> getUserNewsStream(String uid) async* {
    // 1. Yield local data first
    yield* localDataSource.watchUserNews(uid).map(
      (list) => list.map((e) => e.toModel() as UserNews).toList(),
    );

    // 2. Refresh from remote in the background
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getUserNews(uid);
        await localDataSource.cacheUserNews(remoteData.map((e) => e.toLocal()).toList());
      } catch (_) {}
    }
  }
}
