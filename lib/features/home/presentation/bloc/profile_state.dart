import 'package:equatable/equatable.dart';
import 'package:news_ui_kit/features/auth/domain/entities/user.dart';
import 'package:news_ui_kit/features/home/domain/entities/user_news.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.user,
    required this.userNews,
    this.isNewsLoading = false,
  });

  final User user;
  final List<UserNews> userNews;
  final bool isNewsLoading;

  ProfileLoaded copyWith({
    User? user,
    List<UserNews>? userNews,
    bool? isNewsLoading,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      userNews: userNews ?? this.userNews,
      isNewsLoading: isNewsLoading ?? this.isNewsLoading,
    );
  }

  @override
  List<Object?> get props => [user, userNews, isNewsLoading];
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}

class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess();
}

class ProfileError extends ProfileState {
  const ProfileError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
