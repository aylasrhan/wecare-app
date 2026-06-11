
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wecare/features/onboarding/presentation/ui/view/onboadring_contener/role_selection_page.dart';

// تأكد من استيراد ملف صفحة اختيار الدور هنا
// import 'role_selection_page.dart'; 

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _buildPage(
                "assets/images/onboard11.png",
                "Welcome to WeCare",
                "Welcome to our medical app! We're excited to help you manage your healthcare from the comfort of your phone.",
                () => _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease),
              ),
              _buildPage(
                "assets/images/doctor.png",
                "120+ Available Doctors",
                "Please provide us with your medical history including any allergies or current medications.",
                () => _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease),
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
        // This Row is positioned below the PageView in the Column, so we can avoid using Stack.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_currentPage + 1}/3", style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () {}, 
                child: Text("Skip", style: TextStyle(color: Colors.black)),
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
        Image.asset(image, height: 400, fit: BoxFit.contain),
        SizedBox(height: 30),
        
        SmoothPageIndicator(
          controller: _controller,
          count: 3,
          effect: WormEffect(dotHeight: 10, dotWidth: 10, activeDotColor: Colors.blue),
        ),
        SizedBox(height: 30),
        
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E1E66),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              minimumSize: Size(double.infinity, 50),
            ),
            onPressed: onPressed, // هنا نستخدم الوظيفة الممررة
            child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}