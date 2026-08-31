
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';     
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:flutter_easyloading/flutter_easyloading.dart'; 

import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
import 'package:wecare/features/onboarding/presentation/ui/view/onboarding_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';
import 'package:wecare/features/doctor/presentation/ui/view/doctor_today_appointments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  configLoading();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token') ?? prefs.getString('user_token');
  String? role = prefs.getString('roles_name')?.toLowerCase();

  Widget startingPage = OnboardingPage();

  if (token != null && token.isNotEmpty) {
    if (role == 'doctor') {
      startingPage = DoctorAppointmentsScreen();
    } else {
      startingPage = HomeScreenPage();
    }
  }

  runApp(MyApp(startingPage: startingPage));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final Widget startingPage;

  const MyApp({super.key, required this.startingPage});
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => AuthBloc(AuthService()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WeCare',
            home: startingPage, 
            builder: (context, child) {
              return EasyLoading.init()(context, child);
            },
          ),
        );
      },
    );
  }
}