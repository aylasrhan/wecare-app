abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String role;
  LoginEvent(this.email, this.password,{required this.role});
}