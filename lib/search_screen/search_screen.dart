import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repofinderapp/bloc/favorite_repositories_bloc/favorite_repositories_bloc.dart';
import 'package:repofinderapp/bloc/search_bloc/search_bloc.dart';
import 'package:repofinderapp/bloc/webview_bloc/webview_bloc.dart';

import 'package:repofinderapp/widgets/text_field.dart';
import 'package:repofinderapp/result_screen/result_screen.dart';
import 'package:repofinderapp/bloc/validation_cubit/validation_cubit.dart';
import 'package:storage_user_repository/storage_user_repository.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.status == SearchStatus.submitted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<SearchBloc>(),
                  ),
                  BlocProvider(
                    create: (context) => WebViewBloc(),
                  ),
                  BlocProvider(
                    create: (context) => FavoriteRepositoriesBloc(
                      storageUserRepository:
                          context.read<StorageUserRepository>(),
                    )..add(FavoriteRepositoriesInitialEvent()),
                  ),
                ],
                child: const ResultScreen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const _SearchSubmitButton(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                child: BlocBuilder<ValidationCubit, ValidationCubitState>(
                  builder: (context, state) {
                    return SearchTextField(
                        onSubmitted: state.isValid
                            ? () {
                                context
                                    .read<SearchBloc>()
                                    .add(SearchSubmittedEvent(state.value));
                              }
                            : null,
                        onChanged: context.read<ValidationCubit>().onChanged,
                        errorText: !state.isValid
                            ? 'Строка должна содержать больше 3-х символов'
                            : null);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSubmitButton extends StatelessWidget {
  const _SearchSubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationCubitState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: state.isValid
              ? () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context
                      .read<SearchBloc>()
                      .add(SearchSubmittedEvent(state.value));
                }
              : null,
          child: const Icon(Icons.search),
        );
      },
    );
  }
}
