import 'package:flutter/material.dart';
import 'package:repofinderapp/bloc/favorite_repositories_bloc/favorite_repositories_bloc.dart';
import 'package:repofinderapp/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repofinderapp/bloc/webview_bloc/webview_bloc.dart';
import 'package:repofinderapp/favorite_repositories_screen.dart/favorite_repositories_screen.dart';
import 'package:repofinderapp/webview_screen/webview_screen.dart';
import 'package:repofinderapp/widgets/repository_list_item.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  Widget _getDialogItemWithTextStyle(
      {required BuildContext context, required String text}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge ??
          const TextStyle(fontSize: 25),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: const Text('Количество репозиториев'),
                onTap: () async {
                  Future.delayed(
                    Duration.zero,
                    () => showDialog(
                      context: context,
                      builder: (ctx) => SimpleDialog(
                        title: const Text('Количество элементов на страницу:'),
                        children: [
                          SimpleDialogOption(
                            child: _getDialogItemWithTextStyle(
                                context: context, text: '10'),
                            onPressed: () {
                              context
                                  .read<SearchBloc>()
                                  .add(SearchEntriesCountChangedEvent(10));
                              Navigator.pop(context);
                            },
                          ),
                          SimpleDialogOption(
                            child: _getDialogItemWithTextStyle(
                                context: context, text: '25'),
                            onPressed: () {
                              context
                                  .read<SearchBloc>()
                                  .add(SearchEntriesCountChangedEvent(25));
                              Navigator.pop(context);
                            },
                          ),
                          SimpleDialogOption(
                            child: _getDialogItemWithTextStyle(
                                context: context, text: '50'),
                            onPressed: () {
                              context
                                  .read<SearchBloc>()
                                  .add(SearchEntriesCountChangedEvent(50));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: const Text('Сортировка'),
                onTap: () async {
                  Future.delayed(
                    Duration.zero,
                    () => showDialog(
                      context: context,
                      builder: (ctx) {
                        return SimpleDialog(
                          title: const Text('Сортировка по: '),
                          children: [
                            SimpleDialogOption(
                              child: _getDialogItemWithTextStyle(
                                  context: context, text: 'Звёздам'),
                              onPressed: () {
                                context.read<SearchBloc>().add(
                                    SearchSortedEvent(
                                        SearchSortedBy.stargazers));
                                Navigator.pop(context);
                              },
                            ),
                            SimpleDialogOption(
                              child: _getDialogItemWithTextStyle(
                                  context: context, text: 'Просмотрам'),
                              onPressed: () {
                                context.read<SearchBloc>().add(
                                    SearchSortedEvent(SearchSortedBy.watchers));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          BlocBuilder<FavoriteRepositoriesBloc, FavoriteRepositoriesState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<FavoriteRepositoriesBloc>(),
                          ),
                          BlocProvider.value(
                            value: context.read<WebViewBloc>(),
                          ),
                        ],
                        child: const FavoriteRepositoriesScreen(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border, size: 30),
              );
            },
          )
        ],
      ),
      body: BlocListener<WebViewBloc, WebViewState>(
        listener: (context, state) {
          if (state.status == WebViewStatus.submitted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => BlocProvider.value(
                  value: context.read<WebViewBloc>(),
                  child: const WebViewScreen(),
                ),
              ),
            );
          }
        },
        child: const _RepositoryListView(),
      ),
    );
  }
}

class _RepositoryListView extends StatelessWidget {
  const _RepositoryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) =>
          (previous.page != current.page) ||
          (previous.sortedBy != current.sortedBy) ||
          (previous.status != current.status),
      builder: (context, state) {
        if (state.status == SearchStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == SearchStatus.success ||
            state.status == SearchStatus.update) {
          if (state.repositories.isEmpty) {
            return Center(
              child: Text(
                "0 RESULTS",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 24),
              ),
            );
          } else {
            return Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: state.entriesCount,
                    itemBuilder: (context, index) {
                      final repos = state.repositories[index];
                      return RepositoryListItem(
                        repository: repos,
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    if (state.page != 1) ...[
                      IconButton(
                        onPressed: () {
                          context
                              .read<SearchBloc>()
                              .add(SearchPageChangedEvent(state.page - 1));
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ],
                    const Expanded(child: SizedBox()),
                    if (!state.isNextPageEmpty) ...[
                      IconButton(
                        onPressed: () {
                          print('entries: page in button = ${state.page}');
                          context
                              .read<SearchBloc>()
                              .add(SearchPageChangedEvent(state.page + 1));
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ],
                )
              ],
            );
          }
        } else if (state.status == SearchStatus.failure) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: const Text("Too much requests"));
        }
      },
    );
  }
}
