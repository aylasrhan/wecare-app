import 'package:flutter/material.dart';
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false, // لمنع ظهور زر الرجوع
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الصورة التوضيحية (الاحتفال)
            // تأكد من إضافة الصورة في مجلد assets وتغيير المسار هنا
            Image.asset(
              "assets/images/congra.png", 
              height: 300,
            ),
            
            SizedBox(height: 40),
            
            // نص التهنئة
            Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            SizedBox(height: 10),
            
            // نص فرعي
            Text(
              "Your account has been created",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 50),
            
            // زر الانتقال للصفحة الرئيسية
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E1E66),
                minimumSize: Size(200, 55), // حجم الزر كما في الصورة
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreenPage()), // استبدل HomePage باسم الكلاس الخاص بصفحتك الرئيسية
      (route) => false, // هذا الجزء يضمن مسح كل الـ Routes السابقة
    );
                // هنا ننتقل لصفحة التطبيق الرئيسية (Home)
                // Navigator.pushAndRemoveUntil يُستخدم لمسح تاريخ الصفحات السابقة
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
              },
              child: Text(
                "Go Home",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}