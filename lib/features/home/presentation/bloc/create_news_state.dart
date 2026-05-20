import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class CreateNewsState extends Equatable {
  const CreateNewsState();

  @override
  List<Object?> get props => [];
}

class CreateNewsInitial extends CreateNewsState {
  const CreateNewsInitial();
}

/// Image was picked from gallery — holds the local XFile.
class CoverImagePicked extends CreateNewsState {
  const CoverImagePicked({required this.imageFile});

  final XFile imageFile;

  @override
  List<Object?> get props => [imageFile];
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
