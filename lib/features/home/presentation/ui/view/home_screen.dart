
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wecare/features/home/presentation/ui/view/medical_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/more_screen.dart';
import 'package:wecare/features/home/visits/presentation/ui/view/visit_screen.dart';
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
      HomePageContent(), 
      VisitsPage(),
      MedicalPage(),
      MorePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, 
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final bool shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('الخروج من التطبيق', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              content: Text('هل أنت متأكد أنك تريد إغلاق التطبيق؟', style: TextStyle(fontSize: 15.sp)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false), 
                  child: Text('لا', style: TextStyle(fontSize: 14.sp)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), 
                  child: Text('نعم', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                ),
              ],
            );
          },
        ) ?? false;

        if (shouldPop) {
          SystemNavigator.pop(); 
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
          
          iconSize: 24.sp, 
          selectedFontSize: 14.sp,
          unselectedFontSize: 12.sp,
          
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