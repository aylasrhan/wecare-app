import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_event.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_state.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/sign_up.dart';
import 'package:wecare/features/doctor/presentation/ui/view/doctor_today_appointments_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';

class SignInPage extends StatelessWidget {
  final String role; // أضف هذا السطر
  SignInPage({required this.role});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // BlocListener يستمع لتغيرات الحالة ويقوم برد فعل (مثل الانتقال للصفحة التالية)
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
  if (state is AuthSuccess) {
    // استخدم المتغير role المُمرر للصفحة مباشرة، أو افحص الاثنين لضمان الصحة
    print("الدور المُمرر للصفحة هو: $role");
    
    // التحقق بناءً على الدور المرسل أو الدور القادم من الـ state
    if (role.toLowerCase() == 'doctor' || (state.user.role != null && state.user.role.toLowerCase() == 'doctor')) {
      // توجيه الطبيب إلى صفحته الخاصة بالمواعيد
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorTodayAppointmentsScreen()),
      );
    } else {
      // توجيه المريض إلى الصفحة الرئيسية الخاصة بالمريض
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenPage()),
      );
    }
  } else if (state is AuthError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message), backgroundColor: Colors.red),
    );
  }
},
//      listener: (context, state) {
//   if (state is AuthSuccess) {
//     // جلب الدور إما من الـ state القادم من السيرفر أو من المتغير المرسل للصفحة
//     String userRole = state.user.role; // أو استخدام المتغير role الممرر للـ SignInPage

//     if (userRole == 'doctor') {
//       // توجيه الطبيب إلى صفحته الخاصة بالمواعيد
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => DoctorTodayAppointmentsScreen()), // استبدلها بواجهة الطبيب لديك
//       );
//     } else {
//       // توجيه المريض إلى الصفحة الرئيسية الخاصة بالمريض
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreenPage()), // صفحة المريض التي ذكرتها
//       );
//     }
//   } else if (state is AuthError) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//     );
//   }
// },
// listener: (context, state) {
//   if (state is AuthSuccess) {
//     // الآن يمكنك الوصول للدور من خلال state.user.role
//     print("تم تسجيل الدخول بنجاح، الدور هو: ${state.user.role}");
    
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreenPage()),
//     );
//   }
//   // ...
// },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Sign In",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Welcome to WeCare",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),

              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (v) {},
                    activeColor: Color(0xFF1E1E66),
                  ),
                  Text(
                    "Remember password",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // زر تسجيل الدخول
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1E66),
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                emailController.text,
                                passwordController.text,
                                role: role
                              ),
                            );
                          },
                    child: state is AuthLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  );
                },
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF1E1E66),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
