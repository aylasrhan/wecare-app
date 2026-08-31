
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';

class AccountCreatedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Account",
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold,
            fontSize: 20.sp, 
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/congra.png", 
              height: 300.h, 
            ),
            
            SizedBox(height: 40.h), 
            
            Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 28.sp, 
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            SizedBox(height: 10.h),
            
            Text(
              "Your account has been created",
              style: TextStyle(
                fontSize: 16.sp, 
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 50.h),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E66),
                minimumSize: Size(200.w, 55.h), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreenPage()),
                  (route) => false, 
                );
              },
              child: Text(
                "Go Home",
                style: TextStyle(color: Colors.white, fontSize: 18.sp), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}