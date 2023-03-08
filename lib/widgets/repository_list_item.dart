import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_user_repository/search_user_repository.dart';

import 'package:repofinderapp/bloc/favorite_repositories_bloc/favorite_repositories_bloc.dart';
import 'package:repofinderapp/bloc/webview_bloc/webview_bloc.dart';

class RepositoryListItem extends StatelessWidget {
  const RepositoryListItem({
    required this.repository,
    super.key,
  });
  final GitRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebViewBloc, WebViewState>(
      builder: (context, state) {
        return ListTile(
          key: key,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage:
                CachedNetworkImageProvider(repository.userImage ?? ''),
          ),
          title: Text(
              '${repository.username ?? ''}/${repository.reposName ?? ''}'),
          subtitle: Row(
            children: [
              const Icon(Icons.remove_red_eye),
              const SizedBox(width: 5),
              Text(repository.watchers ?? ''),
              const SizedBox(width: 10),
              const Icon(Icons.star),
              const SizedBox(width: 5),
              Text(repository.stargazers ?? ''),
              const Expanded(child: SizedBox()),
              BlocBuilder<FavoriteRepositoriesBloc, FavoriteRepositoriesState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      if (state.reposUrls.contains(repository.reposUrl)) {
                        context.read<FavoriteRepositoriesBloc>().add(
                            FavoriteRepositoriesDeleteEvent(
                                reposIndex: state.reposUrls
                                    .indexOf(repository.reposUrl!)));
                      } else {
                        context.read<FavoriteRepositoriesBloc>().add(
                              FavoriteRepositoriesAddEvent(repository),
                            );
                      }
                    },
                    icon: state.reposUrls.contains(repository.reposUrl)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 30,
                          ),
                  );
                },
              ),
            ],
          ),
          onTap: () {
            context.read<WebViewBloc>().add(WebViewSubmittedEvent(
                repository.reposUrl ?? '', repository.reposName ?? ''));
          },
        );
      },
    );
  }
}
