import 'package:equatable/equatable.dart';
import 'package:news_ui_kit/features/auth/data/user_model.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';

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

  final UserModel user;
  final List<UserNewsModel> userNews;
  final bool isNewsLoading;

  ProfileLoaded copyWith({
    UserModel? user,
    List<UserNewsModel>? userNews,
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
