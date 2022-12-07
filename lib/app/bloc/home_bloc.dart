import 'package:bloc/bloc.dart';
import 'package:masterclass_api/app/events/home_event.dart';
import 'package:masterclass_api/app/repository/anime_repository.dart';
import 'package:masterclass_api/app/states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AnimeRepository repository;

  HomeBloc(this.repository) : super(InitialHomeState()) {
    on<GetAnimeEvent>(_onGetAnime);
    on<LoadingMoreAnimeEvent>(_onLoadingMoreAnime);
  }

  void _onGetAnime(GetAnimeEvent event, Emitter<HomeState> emit) async {
    try {
      emit(LoadingHomeState());

      final listAnimeModel = await repository.search();

      emit(SuccessHomeState(listAnimeModel));
    } catch (error) {
      emit(ErrorHomeState(error.toString()));
    }
  }

  int getPage(int length) {
    return length ~/ 10;
  }

  void _onLoadingMoreAnime(
      LoadingMoreAnimeEvent event, Emitter<HomeState> emit) async {
    try {
      if(state is LoadingMoreHomeState) return;

      final successState = state as SuccessHomeState;
      final data = successState.listAnimeModel;

      emit(LoadingMoreHomeState(data));

      int page = getPage(data.length);

      final listAnimeModel = await repository.search(page: page);

      final list = [...data, ...listAnimeModel];

      emit(SuccessHomeState(list));
    } catch (error) {
      emit(ErrorHomeState(error.toString()));
    }
  }
}
