import 'package:wecare/features/auth/login/data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
// class AuthSuccess extends AuthState {
//   final String? token;
//   AuthSuccess(this.token);
// }
class AuthSuccess extends AuthState {
  final UserModel user; // استبدلي String token بـ UserModel user
  AuthSuccess(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}