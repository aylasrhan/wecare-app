// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';     
// import 'package:wecare/core/services/auth_service.dart';
// import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
// import 'package:wecare/features/onboarding/presentation/ui/view/onboarding_screen.dart';

// void main() {
//   runApp(const MyApp());
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // نقوم بتغليف التطبيق بـ BlocProvider
//     return BlocProvider(
//       create: (context) => AuthBloc(AuthService()),
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'WeCare',
//         home: OnboardingPage(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';     
import 'package:shared_preferences/shared_preferences.dart'; // استيراد المكتبة
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
import 'package:wecare/features/onboarding/presentation/ui/view/onboarding_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart'; // صفحة المريض
import 'package:wecare/features/doctor/presentation/ui/view/doctor_today_appointments_screen.dart'; // صفحة الطبيب

void main() async {
  // 1. التأكد من تهيئة الفلاتر قبل قراءة الذاكرة
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. قراءة الذاكرة لمعرفة إذا كان هناك مستخدم مسجل
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token') ?? prefs.getString('user_token');
  String? role = prefs.getString('roles_name')?.toLowerCase();

  // 3. تحديد الصفحة الافتراضية
  Widget startingPage = OnboardingPage(); // الوضع الافتراضي

  if (token != null && token.isNotEmpty) {
    // إذا كان هناك توكن، نوجهه حسب دوره
    if (role == 'doctor') {
      startingPage = DoctorAppointmentsScreen();
    } else {
      startingPage = HomeScreenPage();
    }
  }

  runApp(MyApp(startingPage: startingPage));
}

class MyApp extends StatelessWidget {
  final Widget startingPage; // متغير لاستقبال الصفحة الافتراضية

  const MyApp({super.key, required this.startingPage});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WeCare',
        home: startingPage, // 🔴 تشغيل الصفحة المناسبة هنا
      ),
    );
  }
}