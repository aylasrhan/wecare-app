
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          print("البوابة المختارة هي: ${widget.role}");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String actualRole = prefs.getString('roles_name')?.toLowerCase() ?? '';
          String requestedPortal = widget.role.toLowerCase();

          if (requestedPortal == 'patient' && actualRole == 'doctor') {
            await prefs.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('عذراً، هذا الحساب خاص بالأطباء. يرجى الدخول من بوابة الأطباء.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (requestedPortal == 'doctor' && actualRole != 'doctor') {
            await prefs.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('عذراً، هذا الحساب خاص بالمرضى. يرجى الدخول من بوابة المرضى.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (actualRole == 'doctor') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DoctorAppointmentsScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreenPage()),
              (Route<dynamic> route) => false,
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w), 
          child: Column(
            children: [
              SizedBox(height: 20.h), 
              Text(
                "Sign In",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold), 
              ),
              SizedBox(height: 10.h),
              Text(
                "Welcome to WeCare",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]), 
              ),
              SizedBox(height: 40.h),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r), 
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                ),
              ),
              SizedBox(height: 20.h),

              TextField(
                controller: passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                ),
              ),

              // Remember Password
              Row(
                children: [
                  Checkbox(
                    value: _rememberPassword,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _rememberPassword = newValue ?? false;
                      });
                    },
                    activeColor: const Color(0xFF1E1E66),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberPassword = !_rememberPassword;
                        });
                      },
                      child: Text(
                        "Remember password",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // Sign In Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 55.h, 
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    emailController.text,
                                    passwordController.text,
                                    role: widget.role,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('الرجاء إدخال البريد الإلكتروني وكلمة المرور'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                      child: state is AuthLoading
                          ? SizedBox(
                              width: 22.w,
                              height: 22.h,
                              child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white, fontSize: 18.sp),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),

              // Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(fontSize: 14.sp)),
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
                        color: const Color(0xFF1E1E66),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}