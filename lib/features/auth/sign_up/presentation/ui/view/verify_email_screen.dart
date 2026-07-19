import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wecare/core/services/auth_service.dart'; // تأكدي من المسار
import 'package:wecare/features/auth/sign_up/presentation/ui/view/success_screen.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // تعريف الـ Controllers للأرقام الأربعة
  final List<TextEditingController> _codeControllers = 
      List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    // تنظيف الـ Controllers عند إغلاق الصفحة
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Verify", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Check your email and verify code", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 40),
            
            // حقول إدخال الكود الأربعة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildCodeField(context, index)),
            ),
            
            SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E1E66),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              // onPressed: () async {
              //   // تجميع الكود من الـ Controllers
              //   String code = _codeControllers.map((c) => c.text).join();
                
              //   if (code.length == 4) {
              //     try {
              //       // استدعاء دالة التفعيل (تأكدي أن الـ AuthService يمرر التوكين في الهيدر)
              //       await AuthService().verifyCode(code);
                    
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(builder: (context) => AccountCreatedPage()),
              //       );
              //     } catch (e) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text("خطأ: الكود غير صحيح أو انتهت صلاحيته")),
              //       );
              //     }
              //   } else {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text("يرجى إدخال الكود كاملاً")),
              //     );
              //   }
              // },
              onPressed: () async {
  String code = _codeControllers.map((c) => c.text).join();
  
  if (code.length == 4) {
    try {
      // استقبال الرد
      var response = await AuthService().verifyCode(code);
      
      // التحقق من أن السيرفر أرجع نجاح
      if (response['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountCreatedPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "الكود غير صحيح")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في الاتصال بالسيرفر")),
      );
    }
  }
},
              child: Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            
            SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't receive code? "),
                GestureDetector(
                  onTap: () async {
                    try {
                      await AuthService().resendCode();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("تم إعادة إرسال الكود")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("فشل إعادة الإرسال")),
                      );
                    }
                  },
                  child: Text("Resend Email", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // تعديل الدالة لتستقبل الـ index وتربط الـ Controller
  Widget _buildCodeField(BuildContext context, int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: _codeControllers[index],
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
          if (value.isEmpty) FocusScope.of(context).previousFocus();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: Theme.of(context).textTheme.headlineSmall,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}