
import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;

  SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}


// for user login data
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterEvent(this.name, this.email, this.password);
}

class LogoutEvent extends AuthEvent {}
