import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          // تأكدي من وضع مسارات الصور الصحيحة هنا
          _buildPage(
            imagePath: "assets/images/onboard1.png", 
            title: "Welcome to WeCare", 
            description: "Welcome to our medical app! We're excited to help you manage your healthcare from the comfort of your phone."
          ),
          _buildPage(
            imagePath: "assets/images/onboard4.png", 
            title: "120+ Available Doctors", 
            description: "Please provide us with your medical history including any allergies or current medications. This information will help us."
          ),
          _buildPage(
            imagePath: "assets/images/onboard3.png", 
            title: "Begin your medical care", 
            description: "you can easily book appointments with your healthcare provider, view your medical records, and receive reminders for upcoming appointments and medications."
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String imagePath, required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // إضافة الصورة هنا
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Image.asset(imagePath, height: 250), // يمكنك التحكم بالحجم
        ),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(description, textAlign: TextAlign.center),
        ),
        ElevatedButton(
          onPressed: () => _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease),
          child: Text("Next"),
        ),
      ],
    );
  }
}