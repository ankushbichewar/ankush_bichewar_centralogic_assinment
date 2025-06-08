// lib/blocs/auth_bloc.dart
import 'package:ankush_bichewar_centralogic_assinment/blocs/movie_event.dart';
import 'package:ankush_bichewar_centralogic_assinment/blocs/movie_state.dart';
import 'package:ankush_bichewar_centralogic_assinment/services/user_data_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogindataStorage storageService;

  AuthBloc(this.storageService) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      final storedUser = await storageService.getUser();
      if (storedUser != null &&
          storedUser.email == event.email &&
          storedUser.password == event.password) {
        emit(Authenticated());
      } else {
        emit(AuthError("Invalid credentials"));
      }
    });

    on<RegisterEvent>((event, emit) async {
      final user = UserModel(
          name: event.name, email: event.email, password: event.password);
      await storageService.saveUser(user);
      emit(Authenticated());
    });

    on<LogoutEvent>((event, emit) async {
      await storageService.clearUser();
      emit(Unauthenticated());
    });
  }
}
