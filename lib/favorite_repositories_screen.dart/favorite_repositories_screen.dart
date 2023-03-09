import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repofinderapp/bloc/webview_bloc/webview_bloc.dart';
import 'package:repofinderapp/widgets/repository_list_item.dart';

import 'package:repofinderapp/bloc/favorite_repositories_bloc/favorite_repositories_bloc.dart';

class FavoriteRepositoriesScreen extends StatelessWidget {
  const FavoriteRepositoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<FavoriteRepositoriesBloc>()
                    .add(FavoriteRepositoriesClearEvent());
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: BlocBuilder<FavoriteRepositoriesBloc, FavoriteRepositoriesState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status != FavoriteRepositoriesStatus.loading) {
            return ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                context.read<FavoriteRepositoriesBloc>().add(
                    FavorireRepositoriesReorderEvent(
                        oldIndex: oldIndex, newIndex: newIndex));
                newIndex = state.newIndex;
              },
              itemCount: state.repositories.length,
              itemBuilder: (context, index) {
                return MultiBlocProvider(
                  key: Key('$index'),
                  providers: [
                    BlocProvider.value(
                      value: context.read<WebViewBloc>(),
                    ),
                    BlocProvider.value(
                      value: context.read<FavoriteRepositoriesBloc>(),
                    ),
                  ],
                  child: RepositoryListItem(
                    repository: state.repositories[index],
                  ),
                );
              },
            );
          } else if (state.repositories.isEmpty) {
            return Center(
              child: Text(
                'No added repositories',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 24),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
