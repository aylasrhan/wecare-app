
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// استيراد الصفحات
import 'package:wecare/features/home/presentation/ui/view/medical_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/more_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/visit_screen.dart';

// 🔴 استيراد صفحة المحتوى اللي فصلناها هلا
import 'package:wecare/features/home/presentation/ui/view/home_page_content.dart'; 

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _currentIndex = 0;
  
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePageContent(), // تم استدعاء الصفحة المفصولة هنا
      VisitsPage(),
      MedicalPage(),
      MorePage(),
    ];
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: IndexedStack(
  //       index: _currentIndex,
  //       children: _pages,
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       type: BottomNavigationBarType.fixed,
  //       selectedItemColor: const Color(0xFF1E1E66),
  //       unselectedItemColor: Colors.grey,
  //       currentIndex: _currentIndex,
  //       onTap: (index) => setState(() => _currentIndex = index),
  //       items: const [
  //         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.calendar_month),
  //           label: "Visits",
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.medical_services),
  //           label: "Medical",
  //         ),
  //         BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // 🔴 استخدام PopScope للتحكم بزر الرجوع
    return PopScope(
      canPop: false, // نمنع الرجوع التلقائي
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        // إظهار رسالة تأكيد الخروج من التطبيق
        final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('الخروج من التطبيق'),
              content: const Text('هل أنت متأكد أنك تريد إغلاق التطبيق؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), // البقاء
                  child: const Text('لا'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), // الخروج
                  child: const Text('نعم', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ?? false;

        if (shouldPop) {
          SystemNavigator.pop(); // يغلق التطبيق بالكامل
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1E1E66),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Visits"),
            BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medical"),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
          ],
        ),
      ),
    );
  }
}