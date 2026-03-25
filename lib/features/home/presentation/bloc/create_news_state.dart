import 'package:equatable/equatable.dart';

abstract class CreateNewsState extends Equatable {
  const CreateNewsState();

  @override
  List<Object?> get props => [];
}

class CreateNewsInitial extends CreateNewsState {
  const CreateNewsInitial();
}

/// Image was picked from gallery — holds the local file path.
class CoverImagePicked extends CreateNewsState {
  const CoverImagePicked({required this.imagePath});

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}

class CreateNewsLoading extends CreateNewsState {
  const CreateNewsLoading();
}

class CreateNewsSuccess extends CreateNewsState {
  const CreateNewsSuccess();
}

class CreateNewsFailure extends CreateNewsState {
  const CreateNewsFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
