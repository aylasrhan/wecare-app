import 'package:flutter/material.dart';
import 'package:wecare/features/auth/login/presentation/ui/view/sign_in.dart';

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E66), // اللون الأزرق الداكن الموجود في الصورة
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleCard(
              context,
              imagePath: "assets/images/patient.png", // تأكد من وضع الصور في المجلد
              title: "Patient Side App",
              onPressed: () {
Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );              },
            ),
            Divider(color: Colors.white24, height: 40, thickness: 1),
            _buildRoleCard(
              context,
              imagePath: "assets/images/doc.png",
              title: "Doctor Side App",
              onPressed: () {
                // انتقل لشاشة تسجيل دخول الطبيب
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required String imagePath, required String title, required VoidCallback onPressed}) {
    return Row(
      children: [
        // الصورة (مربع أبيض حولها)
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(imagePath),
          ),
        ),
        SizedBox(width: 20),
        // النص والزر
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: onPressed,
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}