import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';

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
  final List<String> specialties = ["Cardiology", "Dermatology", "Pediatrics", "Neurology", "General Surgery"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor Registration"), backgroundColor: Color(0xFF1E1E66)),
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
                decoration: InputDecoration(labelText: "Specialty", border: OutlineInputBorder()),
                items: specialties.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => selectedSpecialty = val),
                validator: (val) => val == null ? "Please select a specialty" : null,
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
      await AuthService().register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        passwordConfirmation: passwordController.text,
        role: 'Doctor', // تأكدي أن الدور مكتوب بنفس الطريقة في الـ Controller
        mobile: licenseController.text, // أرسلنا رقم الترخيص في خانة الـ mobile كما اتفقنا
        specialization: selectedSpecialty, // هنا يتم إرسال التخصص الذي اختاره الطبيب
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Created Successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
},
                child: Text("Register as Doctor", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (val) => val!.isEmpty ? "$label is required" : null,
      ),
    );
  }
}