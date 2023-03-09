import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:repofinderapp/bloc/favorite_repositories_bloc/favorite_repositories_bloc.dart';
import 'package:repofinderapp/bloc/search_bloc/search_bloc.dart';
import 'package:repofinderapp/search_screen/search_screen.dart';
import 'package:search_user_repository/search_user_repository.dart';
import 'package:repofinderapp/bloc/validation_cubit/validation_cubit.dart';
import 'package:storage_user_repository/storage_user_repository.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GitRepositoryAdapter());
  await Hive.openBox<List>('favorite_repositories');
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(
    searchUserRepository: SearchUserRepository(),
    storageUserRepository: StorageUserRepository(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    required this.searchUserRepository,
    super.key,
    required this.storageUserRepository,
  });

  final SearchUserRepository searchUserRepository;
  final StorageUserRepository storageUserRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: searchUserRepository,
        ),
        RepositoryProvider.value(
          value: storageUserRepository,
        ),
      ],
      child: MaterialApp(
          title: 'repoFinder',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      SearchBloc(searchUserRepository: searchUserRepository)),
              BlocProvider(create: (context) => ValidationCubit()),
            ],
            child: const SearchScreen(),
          )),
    );
  }
}

// BlocProvider(
                    // create: (context) => FavoriteRepositoriesBloc(
                    //   storageUserRepository:
                    //       context.read<StorageUserRepository>(),
                    // )..add(FavoriteRepositoriesInitialEvent()),
//                   ),