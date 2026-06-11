import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/success_screen.dart';

class VerifyEmailPage extends StatelessWidget {
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
              children: List.generate(4, (index) => _buildCodeField(context)),
            ),
            
            SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E1E66),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AccountCreatedPage()),
  );              },
              child: Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            
            SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't receive code? "),
                GestureDetector(
                  onTap: () {
                    // منطق إعادة إرسال الكود
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

  Widget _buildCodeField(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
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