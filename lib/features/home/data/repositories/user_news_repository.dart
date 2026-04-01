import 'package:news_ui_kit/core/network_info.dart';
import 'package:news_ui_kit/features/home/data/data_sources/user_news_local_data_source.dart';
import 'package:news_ui_kit/features/home/data/data_sources/user_news_remote_data_source.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/domain/repositories/user_news_repository.dart' as domain;

class UserNewsRepository implements domain.UserNewsRepository {
  final UserNewsLocalDataSource localDataSource;
  final UserNewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserNewsRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> createUserNews(UserNewsModel news) async {
    // 1. Save to Local DB first (Optimistic UI)
    await localDataSource.saveUserNews(news.toLocal(isSynced: false));

    // 2. Sync to Firestore if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createUserNews(news);
        // Mark as synced if successful
        await localDataSource.saveUserNews(news.toLocal(isSynced: true));
      } catch (_) {
        // If it fails, stays isSynced = false for later retry
      }
    }
  }

  @override
  Future<void> updateUserNews(UserNewsModel news) async {
    await localDataSource.saveUserNews(news.toLocal(isSynced: false));
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUserNews(news);
        await localDataSource.saveUserNews(news.toLocal(isSynced: true));
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
  Future<List<UserNewsModel>> getUserNews(String uid) async {
    // Return disk data first
    final localList = await localDataSource.getUserNews(uid);
    
    // Background fetch if online
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getUserNews(uid);
        await localDataSource.cacheUserNews(remoteData.map((e) => e.toLocal()).toList());
        return remoteData;
      } catch (_) {}
    }
    
    return localList.map((e) => e.toModel()).toList();
  }

  @override
  Stream<List<UserNewsModel>> getUserNewsStream(String uid) async* {
    // 1. Yield local data first
    yield* localDataSource.watchUserNews(uid).map(
      (list) => list.map((e) => e.toModel()).toList(),
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
