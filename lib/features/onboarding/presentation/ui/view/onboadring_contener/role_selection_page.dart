
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/auth/login/presentation/ui/view/sign_in.dart';
import 'package:wecare/features/doctor/presentation/ui/view/sign_up.dart';

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E66), 
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleCard(
              context,
              imagePath: "assets/images/patient.png", 
              title: "Patient Side App",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage(role: 'patient')),
                );              
              },
            ),
            Divider(color: Colors.white24, height: 40.h, thickness: 1.h), 
            _buildRoleCard(
              context,
              imagePath: "assets/images/doc.png",
              title: "Doctor Side App",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorSignUpPage()), 
                );              
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
        Container(
          height: 80.h, 
          width: 80.w, 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r), 
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w), 
            child: Image.asset(imagePath),
          ),
        ),
        SizedBox(width: 20.w), 
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 20.sp, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h), 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), 
                ),
                onPressed: onPressed,
                child: Text("Next", style: TextStyle(fontSize: 14.sp)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}