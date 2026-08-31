
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/onboarding/presentation/ui/view/onboadring_contener/role_selection_page.dart';
import 'package:wecare/features/home/presentation/ui/widgets/profile_text_field.dart'; // 🔴 استيراد الودجت المنفصل

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true; 

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final data = await AuthService().getUserProfile();

      if (!mounted) return;

      if (data['success'] == true && data['patient'] != null) {
        final patient = data['patient'];

        setState(() {
          nameController.text = patient['f_name'] ?? "";
          emailController.text = patient['user'] != null
              ? patient['user']['email'] ?? ""
              : "";
          mobileController.text = patient['mobile'] ?? "";
          addressController.text = patient['address'] ?? "";

          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("حدث خطأ أثناء جلب البيانات")),
        );
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RoleSelectionPage()), 
      (route) => false,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile", 
          style: TextStyle(color: Colors.black, fontSize: 20.sp), 
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF1E1E66)),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(20.w), 
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50.r, 
                        backgroundColor: const Color(0xFFE8EAF6),
                        child: Icon(
                          Icons.person,
                          size: 50.sp, 
                          color: const Color(0xFF1E1E66),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Change Photo",
                        style: TextStyle(
                          color: const Color(0xFF1E1E66),
                          fontSize: 16.sp, 
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h), 

                    ProfileTextField(label: "Name", controller: nameController),
                    ProfileTextField(label: "Email", controller: emailController),
                    ProfileTextField(label: "Mobile Number", controller: mobileController),
                    ProfileTextField(label: "Address", controller: addressController),

                    SizedBox(height: 30.h), 

                    TextButton.icon(
                      onPressed: _logout,
                      icon: Icon(Icons.logout, color: Colors.red, size: 24.sp), 
                      label: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.red, fontSize: 18.sp), 
                      ),
                    ),
                    SizedBox(height: 20.h), 
                  ],
                ),
              ),
      ),
    );
  }
}