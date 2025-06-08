import 'package:ankush_bichewar_centralogic_assinment/services/user_data_storage.dart';
import 'package:ankush_bichewar_centralogic_assinment/splash/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ankush_bichewar_centralogic_assinment/blocs/movie_bloc.dart';
import 'package:ankush_bichewar_centralogic_assinment/blocs/movie_event.dart';
import 'package:ankush_bichewar_centralogic_assinment/blocs/auth_bloc.dart';
import 'package:ankush_bichewar_centralogic_assinment/repository/movie_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepository>(
          create: (_) => MovieRepository(),
        ),
        RepositoryProvider<LogindataStorage>(
          create: (_) => LogindataStorage(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
            create: (context) => MovieBloc(context.read<MovieRepository>())..add(LoadMovies()),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(context.read<LogindataStorage>()),
          ),
        ],
        child:  const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie Search App',
          home: WelcomePage(),
        ),
      ),
    );
  }
}
