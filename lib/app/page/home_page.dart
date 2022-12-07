import 'package:flutter/material.dart';
import 'package:masterclass_api/app/bloc/home_bloc.dart';
import 'package:masterclass_api/app/events/home_event.dart';
import 'package:masterclass_api/app/model/anime_model.dart';
import 'package:masterclass_api/app/repository/anime_repository.dart';
import 'package:masterclass_api/app/states/home_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc homeBloc = HomeBloc(AnimeRepository());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    homeBloc.add(GetAnimeEvent());
    _scrollController.addListener(listenerScroll);
  }

  void listenerScroll() {
    ScrollPosition scrollPosition = _scrollController.position;

    if (scrollPosition.pixels == scrollPosition.maxScrollExtent) {
      homeBloc.add(LoadingMoreAnimeEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(listenerScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Masterclass 5'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<HomeState>(
          stream: homeBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.data is LoadingHomeState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data is ErrorHomeState) {
              final error = snapshot.data as ErrorHomeState;
              return Center(
                child: Text(
                  error.message,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              );
            }

            if(snapshot.data is InitialHomeState) {
              return Container();
            }

            // LoadingMoreHomeState
            late List<AnimeModel> listAnimeModel;

            if (snapshot.data is SuccessHomeState) {
              final state = snapshot.data as SuccessHomeState;
              listAnimeModel = state.listAnimeModel;
            } else if(snapshot.data is LoadingMoreHomeState) {
              final state = snapshot.data as LoadingMoreHomeState;
              listAnimeModel = state.listAnimeModel;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: listAnimeModel.length,
                    itemBuilder: (context, index) {
                      final item = listAnimeModel.elementAt(index);

                      final title = item.title;
                      final description = item.description;
                      final date = item.date;
                      final link = item.link;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${date.day}/${date.month}/${date.year}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () => launchUrlString(link),
                                  child: const Text(
                                    'Acessar matéria',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if(snapshot.data is LoadingMoreHomeState)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
