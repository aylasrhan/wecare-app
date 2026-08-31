
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/verify_email_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedNationality, selectedBloodType, selectedSex, selectedCity;
  List<String> nationalityList = [];
  List<String> cityList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    motherNameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void loadData() async {
    try {
      var nationalities = await AuthService().getNationalities();
      setState(() => nationalityList = nationalities);
    } catch (e) {
      print("خطأ في جلب الجنسيات: $e");
    }

    try {
      var cities = await AuthService().getCities();
      setState(() => cityList = cities);
    } catch (e) {
      print("خطأ في جلب المدن: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w), 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50.h), 
              Text(
                "Sign Up", 
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold) 
              ),
              SizedBox(height: 20.h),
              
              _buildTextField("Name", controller: nameController),
              _buildTextField("Your Email", controller: emailController),
              _buildTextField("Password", controller: passwordController, isPassword: true),
              _buildTextField("Repeat Password", controller: confirmPasswordController, isPassword: true),
              _buildTextField("Mother Name", controller: motherNameController),
              _buildTextField("Mobile number", controller: mobileController, isNumber: true),
              _buildTextField("Address", controller: addressController),

              _buildDropdown("Select Nationality", nationalityList, selectedNationality, (val) => setState(() => selectedNationality = val)),
              _buildDropdown("Select Blood Type", ["A+", "A-", "B+", "B-", "O+", "O-"], selectedBloodType, (val) => setState(() => selectedBloodType = val)),
              _buildDropdown("Select Sex", ["Male", "Female"], selectedSex, (val) => setState(() => selectedSex = val)),
              _buildDropdown("Select City", cityList, selectedCity, (val) => setState(() => selectedCity = val)),
              
              Padding(
                padding: EdgeInsets.only(bottom: 15.h), 
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "BirthDate", 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)) 
                    ),
                    child: Text(_selectedDate == null ? "Choose Date" : intl.DateFormat('MM/dd/yyyy').format(_selectedDate!)),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E66),
                  minimumSize: Size(double.infinity, 50.h), 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), 
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await AuthService().register(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        passwordConfirmation: confirmPasswordController.text,
                        role: 'patient',
                        motherName: motherNameController.text,
                        mobile: mobileController.text,
                        birthDate: _selectedDate != null ? intl.DateFormat('MM/dd/yyyy').format(_selectedDate!) : null,
                        sex: selectedSex == 'Male' ? 1 : (selectedSex == 'Female' ? 2 : null),
                        blood: selectedBloodType,
                        city: selectedCity != null ? cityList.indexOf(selectedCity!) + 1 : null,
                        nationality: selectedNationality != null ? nationalityList.indexOf(selectedNationality!) + 1 : null,
                        address: addressController.text,
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h), 
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)), 
        ),
        validator: (value) => value!.isEmpty ? "Field Required" : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? currentValue,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h), 
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)), 
          filled: true,
          fillColor: items.isEmpty ? Colors.grey[200] : Colors.white,
        ),
        value: (items.contains(currentValue)) ? currentValue : null,
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: items.isEmpty ? null : onChanged,
        hint: Text(items.isEmpty ? "جاري التحميل..." : "اختر $label"),
      ),
    );
  }
}