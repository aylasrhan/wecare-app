import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/login/presentation/ui/view/sign_in.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/verify_email_screen.dart';

class DoctorSignUpPage extends StatefulWidget {
  @override
  _DoctorSignUpPageState createState() => _DoctorSignUpPageState();
}

class _DoctorSignUpPageState extends State<DoctorSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();

  String? selectedSpecialty;
  final List<String> specialties = [
    "Cardiology",
    "Dermatology",
    "Pediatrics",
    "Neurology",
    "General Surgery",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Registration"),
        backgroundColor: Color(0xFF1E1E66),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.medical_services, size: 80, color: Color(0xFF1E1E66)),
              SizedBox(height: 20),
              _buildTextField("Full Name", nameController),
              _buildTextField("Email Address", emailController),
              _buildTextField("Password", passwordController, isPassword: true),
              _buildTextField("Medical License Number", licenseController),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Specialty",
                  border: OutlineInputBorder(),
                ),
                items: specialties
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => selectedSpecialty = val),
                validator: (val) =>
                    val == null ? "Please select a specialty" : null,
              ),

              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E66),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // 1. استلام الرد من السيرفر (يجب أن ترجع الدالة الـ response أو البيانات)
                      final response = await AuthService().register(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        passwordConfirmation: passwordController.text,
                        role: 'Doctor',
                        mobile: licenseController.text,
                        specialization: selectedSpecialty,
                      );

                      // 2. التحقق من حالة النجاح
                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Account Created Successfully"),
                          ),
                        );
                        // 3. الانتقال لصفحة التحقق هنا فقط
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyEmailPage(),
                          ), // تأكدي من اسم صفحتك
                        );
                      } else {
                        // 4. عرض رسالة الخطأ القادمة من السيرفر (مثل: الإيميل موجود مسبقاً)
                        String errorMessage = response['msg'] is Map
                            ? response['msg'].values.first.first
                            : response['msg'].toString();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $errorMessage"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      // التعامل مع أخطاء الشبكة أو الاستثناءات
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed: ${e.toString()}")),
                      );
                    }
                  }
                },
                child: Text(
                  "Register as Doctor",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),

// سطر الانتقال إلى صفحة تسجيل الدخول إذا كان لديه حساب مسبق
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text("Already have an account? ", style: TextStyle(color: Colors.grey[700])),
    GestureDetector(
      onTap: () {
        // الانتقال لصفحة الـ Sign In مع تمرير دور الطبيب 'doctor'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(role: 'doctor'),
          ),
        );
      },
      child: Text(
        "Sign In",
        style: TextStyle(
          color: Color(0xFF1E1E66),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
            ],
            
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) => val!.isEmpty ? "$label is required" : null,
      ),
    );
  }
}
