
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_event.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_state.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/sign_up.dart';
import 'package:wecare/features/doctor/presentation/ui/view/doctor_today_appointments_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';

class SignInPage extends StatefulWidget {
  final String role;
  SignInPage({required this.role});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  bool _isPasswordHidden = true; 
  
  bool _rememberPassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async { // 🔴 التعديل هنا: أضفنا async
        if (state is AuthSuccess) {
          print("البوابة المختارة هي: ${widget.role}");
          
          // 1. جلب الدور الحقيقي الذي تم حفظه للتو من السيرفر
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String actualRole = prefs.getString('roles_name')?.toLowerCase() ?? '';
          String requestedPortal = widget.role.toLowerCase();

          // 2. التحقق: طبيب يحاول الدخول من بوابة المرضى
          if (requestedPortal == 'patient' && actualRole == 'doctor') {
            await prefs.clear(); // مسح البيانات فوراً (إلغاء الدخول)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('عذراً، هذا الحساب خاص بالأطباء. يرجى الدخول من بوابة الأطباء.'),
                backgroundColor: Colors.red,
              ),
            );
            return; // إيقاف العملية وعدم الانتقال
          }

          // 3. التحقق: مريض يحاول الدخول من بوابة الأطباء
          if (requestedPortal == 'doctor' && actualRole != 'doctor') {
            await prefs.clear(); // مسح البيانات فوراً (إلغاء الدخول)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('عذراً، هذا الحساب خاص بالمرضى. يرجى الدخول من بوابة المرضى.'),
                backgroundColor: Colors.red,
              ),
            );
            return; // إيقاف العملية وعدم الانتقال
          }

          // 4. إذا كان كل شيء صحيحاً، يتم التوجيه للصفحة المناسبة
          // if (actualRole == 'doctor') {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => DoctorAppointmentsScreen()),
          //   );
          // } else {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => HomeScreenPage()),
          //   );
          // }
          // 4. إذا كان كل شيء صحيحاً، يتم التوجيه للصفحة المناسبة
          if (actualRole == 'doctor') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DoctorAppointmentsScreen()),
              (Route<dynamic> route) => false, // 🔴 تمسح السجل بالكامل
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreenPage()),
              (Route<dynamic> route) => false, // 🔴 تمسح السجل بالكامل
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
    // return BlocListener<AuthBloc, AuthState>(
    //   listener: (context, state) {
    //     if (state is AuthSuccess) {
    //       print("الدور المُمرر للصفحة هو: ${widget.role}");
          
    //       if (widget.role.toLowerCase() == 'doctor' || (state.user.role != null && state.user.role.toLowerCase() == 'doctor')) {
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(builder: (context) => DoctorAppointmentsScreen()),
    //         );
    //       } else {
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(builder: (context) => HomeScreenPage()),
    //         );
    //       }
    //     } else if (state is AuthError) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text(state.message), backgroundColor: Colors.red),
    //       );
    //     }
    //   },
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
                obscureText: _isPasswordHidden, 
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
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
                    value: _rememberPassword,   
                    onChanged: (bool? newValue) {
                      setState(() {
                        _rememberPassword = newValue ?? false;
                      });
                    },
                    activeColor: Color(0xFF1E1E66),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberPassword = !_rememberPassword;
                      });
                    },
                    child: Text(
                      "Remember password",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

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
                                role: widget.role, 
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