
// import 'package:flutter/material.dart';
// import 'package:wecare/features/auth/sign_up/presentation/ui/view/sign_up.dart';

// class SignInPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Text("Sign In", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text("Welcome to WeCare", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
//             SizedBox(height: 40),
            
//             // حقل البريد
//             TextField(
//               decoration: InputDecoration(
//                 labelText: "Email",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               ),
//             ),
//             SizedBox(height: 20),
            
//             // حقل كلمة المرور
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               ),
//             ),
            
//             Row(
//               children: [
//                 Checkbox(value: false, onChanged: (v) {}, activeColor: Color(0xFF1E1E66)),
//                 Text("Remember password", style: TextStyle(color: Colors.grey[700])),
//               ],
//             ),
            
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () {}, 
//               child: Text("Forgot password?", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold))
//             ),
            
//             SizedBox(height: 30),
            
//             // زر Sign In
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF1E1E66),
//                 minimumSize: Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               ),
//               onPressed: () {},
//               child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18)),
//             ),
            
//             SizedBox(height: 20),
            
//             // رابط Sign Up
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Don't have an account? "),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SignUpPage()),
//         );
//                   },
//                   child: Text("Sign Up", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_bloc.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_event.dart';
import 'package:wecare/features/auth/login/presentation/cubit/auth_state.dart';
import 'package:wecare/features/auth/sign_up/presentation/ui/view/sign_up.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // BlocListener يستمع لتغيرات الحالة ويقوم برد فعل (مثل الانتقال للصفحة التالية)
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // هنا يتم الانتقال للهوم بعد نجاح تسجيل الدخول
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreenPage()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful!")));
        } else if (state is AuthError) {
          // إظهار رسالة خطأ إذا فشل الدخول
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("Sign In", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Welcome to WeCare", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 40),
              
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              SizedBox(height: 20),
              
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              
              Row(
                children: [
                  Checkbox(value: false, onChanged: (v) {}, activeColor: Color(0xFF1E1E66)),
                  Text("Remember password", style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              
              SizedBox(height: 30),
              
              // زر تسجيل الدخول
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1E66),
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: state is AuthLoading 
                        ? null 
                        : () {
                            context.read<AuthBloc>().add(
                              LoginEvent(emailController.text, passwordController.text)
                            );
                          },
                    child: state is AuthLoading 
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18)),
                  );
                },
              ),
              
              SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text("Sign Up", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}