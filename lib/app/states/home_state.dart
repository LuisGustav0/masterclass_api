import 'package:masterclass_api/app/model/anime_model.dart';

abstract class HomeState {}

class InitialHomeState implements HomeState {}

class LoadingHomeState implements HomeState {}

class ErrorHomeState implements HomeState {
  final String message;

  ErrorHomeState(this.message);
}

class SuccessHomeState implements HomeState {
  final List<AnimeModel> listAnimeModel;

  SuccessHomeState(this.listAnimeModel);
}

class LoadingMoreHomeState implements HomeState {
  final List<AnimeModel> listAnimeModel;

  LoadingMoreHomeState(this.listAnimeModel);
}