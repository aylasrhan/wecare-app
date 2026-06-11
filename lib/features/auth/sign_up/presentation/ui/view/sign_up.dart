
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wecare/features/auth/sign_up/presentation/ui/view/verify_email_screen.dart'; // ستحتاج لإضافة حزمة intl في ملف pubspec.yaml لتنسيق التاريخ

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate; // متغير لتخزين التاريخ المختار

  // دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
              
              _buildDropdown("Select Nationality", ["Syrian", "Other"]),
              _buildDropdown("Select Blood Type", ["A+", "A-", "B+", "B-", "O+", "O-"]),
              _buildDropdown("Select Sex", ["Male", "Female"]),
              _buildDropdown("Select City", ["Damascus", "Aleppo", "Homs", "Other"]),
              
              // حقل تاريخ الميلاد
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "BirthDate",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(_selectedDate == null 
                        ? "Please Choose your birthDate" 
                        : intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E66),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmailPage()),
      );
                  }
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              
              SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text("Or")),
                  Expanded(child: Divider()),
                ],
              ),
              
              SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text("Sign In", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label, 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}