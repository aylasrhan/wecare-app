
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      print("جاري تسجيل الدخول كـ: ${event.role}"); 
      emit(AuthLoading()); 
      
try {
  final user = await authService.login(event.email, event.password);
  
  if (user.token.isNotEmpty) {
    emit(AuthSuccess(user));
  } else {
    emit(AuthError("لم يتم استلام رمز دخول صحيح"));
  }
} catch (e) {
  emit(AuthError(e.toString()));
}
    });
  }
}