// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wecare/core/services/auth_service.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthService authService;

//   AuthBloc(this.authService) : super(AuthInitial()) {
//     on<LoginEvent>((event, emit) async {
//       print("جاري تسجيل الدخول كـ: " + event.role); // أضف هذا السطر
//       emit(AuthLoading()); // حالة التحميل
//       try {
//         final user = await authService.login(event.email, event.password);
        
//         emit(AuthSuccess(user.token)); // النجاح وتمرير الـ Token
//       } catch (e) {
//         emit(AuthError(e.toString())); // إظهار الخطأ
//       }
//     });
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      // استخدام الـ Interpolation (${}) آمن أكثر عند الطباعة لتجنب الـ null
      print("جاري تسجيل الدخول كـ: ${event.role}"); 
      emit(AuthLoading()); // حالة التحميل
      
    // داخل ملف auth_bloc.dart
try {
  final user = await authService.login(event.email, event.password);
  
  // تأكدي من أن التوكن ليس فارغاً
  if (user.token.isNotEmpty) {
    emit(AuthSuccess(user)); // أرسلي كائن user بالكامل وليس user.token فقط
  } else {
    emit(AuthError("لم يتم استلام رمز دخول صحيح"));
  }
} catch (e) {
  emit(AuthError(e.toString()));
}
    });
  }
}