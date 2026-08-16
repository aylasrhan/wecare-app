// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class DoctorService {
//   final String baseUrl = "http://10.0.2.2:8000/api/";

//   // دالة لجلب مواعيد الطبيب لليوم
//   Future<List<dynamic>> getDoctorTodayAppointments() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('user_token');

//     final response = await http.get(
//       Uri.parse('${baseUrl}doctor-today-appointments'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       // تأكدي من أن اسم المفتاح في الـ JSON المرجوع من الـ Controller هو 'appointments'
//       return data['appointments'] ?? []; 
//     } else {
//       throw Exception('فشل جلب مواعيد اليوم: ${response.statusCode}');
//     }
//   }

//   // دالة لجلب أسئلة المرضى للطبيب
//   Future<List<dynamic>> getDoctorQuestions() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('user_token');

//     final response = await http.get(
//       Uri.parse('${baseUrl}doctor_questions'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       // تأكدي من أن اسم المفتاح في الـ JSON المرجوع من الـ Controller هو 'questions'
//       return data['questions'] ?? []; 
//     } else {
//       throw Exception('فشل جلب الأسئلة: ${response.statusCode}');
//     }
//   }
// }