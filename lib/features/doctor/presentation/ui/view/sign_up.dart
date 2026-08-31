

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';   
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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Registration", 
          style: TextStyle(fontSize: 20.sp) 
        ),
        backgroundColor: const Color(0xFF1E1E66),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w), 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.medical_services, size: 80.sp, color: const Color(0xFF1E1E66)), 
              SizedBox(height: 20.h), 
              
              _buildTextField("Full Name", nameController),
              _buildTextField("Email Address", emailController),
              _buildTextField("Password", passwordController, isPassword: true),
              _buildTextField("Medical License Number", licenseController),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Specialty",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r) 
                  ),
                ),
                items: specialties
                    .map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: 16.sp)))) 
                    .toList(),
                onChanged: (val) => setState(() => selectedSpecialty = val),
                validator: (val) =>
                    val == null ? "Please select a specialty" : null,
              ),

              SizedBox(height: 30.h), 
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E66),
                  minimumSize: Size(double.infinity, 50.h), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r), 
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final response = await AuthService().register(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        passwordConfirmation: passwordController.text,
                        role: 'Doctor',
                        mobile: licenseController.text,
                        specialization: selectedSpecialty,
                      );

                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account Created Successfully"),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyEmailPage(),
                          ), 
                        );
                      } else {
                        String errorMessage = response['msg'] is Map
                            ? response['msg'].values.first.first
                            : response['msg'].toString();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $errorMessage", style: TextStyle(fontSize: 14.sp)), 
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed: ${e.toString()}", style: TextStyle(fontSize: 14.sp))),
                      );
                    }
                  }
                },
                child: Text(
                  "Register as Doctor",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp), 
                ),
              ),
              SizedBox(height: 20.h), 

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.grey[700], fontSize: 14.sp)), 
                  GestureDetector(
                    onTap: () {
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
                        color: const Color(0xFF1E1E66),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp, 
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
      padding: EdgeInsets.only(bottom: 15.h), 
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(fontSize: 16.sp), 
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14.sp), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r), 
          ),
        ),
        validator: (val) => val!.isEmpty ? "$label is required" : null,
      ),
    );
  }
}