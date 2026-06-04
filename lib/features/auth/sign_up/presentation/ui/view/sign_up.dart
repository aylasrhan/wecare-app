import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // استخدم Controller لكل حقل إذا كنت ستتعامل مع البيانات لاحقاً
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Sign Up", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text("Create Your Account"),
              SizedBox(height: 20),
              
              _buildTextField("Name"),
              _buildTextField("Your Email"),
              _buildTextField("Password", isPassword: true),
              _buildTextField("Repeat Password", isPassword: true),
              _buildTextField("Mother Name"),
              _buildTextField("Mobile number", isNumber: true),
              _buildTextField("Address"),
              
              // للقوائم المنسدلة (Dropdowns)
              _buildDropdown("Select Nationality", ["Syrian", "Other"]),
              _buildDropdown("Select Blood Type", ["A+", "A-", "B+", "B-", "O+", "O-"]),
              _buildDropdown("Select Sex", ["Male", "Female"]),
              
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E66),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // تنفيذ عملية التسجيل
                  }
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget مخصص للحقول لتقليل تكرار الكود
  Widget _buildTextField(String label, {bool isPassword = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // Widget مخصص للـ Dropdown
  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}