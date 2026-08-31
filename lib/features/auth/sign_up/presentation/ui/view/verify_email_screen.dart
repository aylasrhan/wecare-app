
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/success_screen.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _codeControllers = 
      List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
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
          icon: Icon(Icons.close, color: Colors.black, size: 24.sp), 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w), 
        child: Column(
          children: [
            SizedBox(height: 20.h), 
            Text(
              "Verify", 
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 10.h),
            Text(
              "Check your email and verify code", 
              style: TextStyle(color: Colors.grey, fontSize: 16.sp) 
            ),
            SizedBox(height: 40.h),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildCodeField(context, index)),
            ),
            
            SizedBox(height: 40.h),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E66),
                minimumSize: Size(double.infinity, 50.h), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r) 
                ),
              ),
              onPressed: () async {
                String code = _codeControllers.map((c) => c.text).join();
                
                if (code.length == 4) {
                  try {
                    var response = await AuthService().verifyCode(code);
                    
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
                      const SnackBar(content: Text("خطأ في الاتصال بالسيرفر")),
                    );
                  }
                }
              },
              child: Text(
                "Continue", 
                style: TextStyle(color: Colors.white, fontSize: 16.sp) 
              ),
            ),
            
            SizedBox(height: 20.h),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't receive code? ", style: TextStyle(fontSize: 14.sp)),
                GestureDetector(
                  onTap: () async {
                    try {
                      await AuthService().resendCode();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تم إعادة إرسال الكود")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("فشل إعادة الإرسال")),
                      );
                    }
                  },
                  child: Text(
                    "Resend Email", 
                    style: TextStyle(color: const Color(0xFF1E1E66), fontWeight: FontWeight.bold, fontSize: 14.sp) // 🔴 خط متجاوب
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeField(BuildContext context, int index) {
    return SizedBox(
      width: 60.w, 
      height: 60.w, 
      child: TextFormField(
        controller: _codeControllers[index],
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
          if (value.isEmpty) FocusScope.of(context).previousFocus();
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)), 
        ),
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black),
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