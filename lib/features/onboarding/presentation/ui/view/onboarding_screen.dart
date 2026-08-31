
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/onboarding/presentation/ui/view/onboadring_contener/role_selection_page.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_currentPage + 1}/3", 
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold) 
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RoleSelectionPage()),
                      );
                    },
                    child: Text(
                      "Skip", 
                      style: TextStyle(color: Colors.black, fontSize: 16.sp) // 🔴 خط متجاوب
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildPage(
                  "assets/images/onboard11.png",
                  "Welcome to WeCare",
                  "Welcome to our medical app! We're excited to help you manage your healthcare from the comfort of your phone.",
                  () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                ),
                _buildPage(
                  "assets/images/doctor.png",
                  "120+ Available Doctors",
                  "Please provide us with your medical history including any allergies or current medications.",
                  () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                ),
                _buildPage(
                  "assets/images/doctor2.png",
                  "Begin your medical care",
                  "You can easily book appointments with your healthcare provider and view records.",
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RoleSelectionPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String image, String title, String description, VoidCallback onPressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image, 
          height: 350.h,
          fit: BoxFit.contain,
        ), 
        SizedBox(height: 30.h), 
        
        Text(
          title, 
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold) 
        ),
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h), 
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]), 
          ),
        ),
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h), 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E66),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
              minimumSize: Size(double.infinity, 50.h), 
            ),
            onPressed: onPressed,
            child: Text(
              "Next", 
              style: TextStyle(color: Colors.white, fontSize: 16.sp) 
            ),
          ),
        ),
      ],
    );
  }
}