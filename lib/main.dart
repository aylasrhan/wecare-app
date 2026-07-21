import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // لا تنسي عمل import
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
import 'package:wecare/features/doctor/presentation/ui/view/doctor_appointments_screen.dart';
import 'package:wecare/features/onboarding/presentation/ui/view/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // نقوم بتغليف التطبيق بـ BlocProvider
    return BlocProvider(
      create: (context) => AuthBloc(AuthService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WeCare',
        home: OnboardingPage(),
      ),
    );
  }
}