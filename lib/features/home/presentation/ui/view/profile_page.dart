
import 'package:flutter/material.dart';
import 'package:wecare/features/auth/login/presentation/ui/view/sign_in.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage("https://via.placeholder.com/150"), // استبدليها بصورة المستخدم
                ),
              ),
              TextButton(onPressed: () {}, child: Text("Change Photo")),
              SizedBox(height: 20),
              _buildTextField("Name", "jgjhgj"),
              _buildTextField("Email", "w71@gmail.com"),
              _buildTextField("Mobile Number", "Your Mobile Number"),
              _buildTextField("Address", "مشروع دمر"),
              SizedBox(height: 30),
              TextButton.icon(
                onPressed: () {
    // قومي بإضافة كود حذف التوكين أو بيانات الجلسة هنا إذا وجد (مثلاً SharedPreferences)
    
    // الانتقال لصفحة تسجيل الدخول وحذف كل الصفحات السابقة من الذاكرة
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage(role: "Patient",)), // استبدلي LoginPage باسم صفحة تسجيل الدخول لديك
      (route) => false,
    );
  },
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text("Log Out", style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 16)),
        SizedBox(height: 5),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wecare/core/services/auth_service.dart'; // تأكد من صحة مسار الاستيراد
// import 'package:wecare/features/auth/login/presentation/ui/view/sign_in.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool isLoading = true; // للتحكم في شاشة التحميل

//   // Controllers للتحكم في الحقول بشكل صحيح
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchProfileData();
//   }

//   // دالة جلب البيانات من السيرفر
//   Future<void> fetchProfileData() async {
//     try {
//       final data = await AuthService().getUserProfile();

//       if (!mounted) return;

//       if (data['success'] == true && data['patient'] != null) {
//         final patient = data['patient'];

//         setState(() {
//           // تعبئة البيانات القادمة من السيرفر داخل الحقول
//           nameController.text = patient['f_name'] ?? "";
//           // الإيميل موجود داخل كائن user الفرعي
//           emailController.text = patient['user'] != null
//               ? patient['user']['email'] ?? ""
//               : "";
//           mobileController.text = patient['mobile'] ?? "";
//           addressController.text = patient['address'] ?? "";

//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching profile: $e");
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("حدث خطأ أثناء جلب البيانات")),
//         );
//       }
//     }
//   }

//   // دالة تسجيل الخروج ومسح الذاكرة
//   Future<void> _logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user_token');
//     await prefs.remove('roles_name');

//     if (!mounted) return;

//     // الانتقال لصفحة تسجيل الدخول وحذف كل الصفحات السابقة من الذاكرة
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => SignInPage(role: "Patient")),
//       (route) => false,
//     );
//   }

//   @override
//   void dispose() {
//     // تنظيف الكنترولرز عند الخروج من الشاشة لتجنب تسريب الذاكرة
//     nameController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Profile", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SafeArea(
//         child: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF1E1E66)),
//               )
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     const Center(
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Color(0xFFE8EAF6),
//                         child: Icon(
//                           Icons.person,
//                           size: 50,
//                           color: Color(0xFF1E1E66),
//                         ),
//                         // backgroundImage: NetworkImage("URL"), // فعّلها إذا كان هناك صورة من السيرفر
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         "Change Photo",
//                         style: TextStyle(color: Color(0xFF1E1E66)),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     _buildTextField("Name", nameController),
//                     _buildTextField("Email", emailController),
//                     _buildTextField("Mobile Number", mobileController),
//                     _buildTextField("Address", addressController),

//                     const SizedBox(height: 30),

//                     TextButton.icon(
//                       onPressed: _logout,
//                       icon: const Icon(Icons.logout, color: Colors.red),
//                       label: const Text(
//                         "Log Out",
//                         style: TextStyle(color: Colors.red, fontSize: 18),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   // تم تعديل هذه الدالة لتستقبل TextEditingController
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
//         const SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           readOnly:
//               true, // جعلنا الحقل للقراءة فقط (إلا إذا كنت تريد تفعيل التعديل لاحقاً)
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             filled: true,
//             fillColor: Colors.grey[100],
//           ),
//         ),
//         const SizedBox(height: 15),
//       ],
//     );
//   }
// }