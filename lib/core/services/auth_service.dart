
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/auth/login/data/models/user_model.dart';
import 'package:wecare/model/doctor_model.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api/";

  Future<UserModel> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('${baseUrl}Api_login'),
    body: {'email': email, 'password': password},
  );
  
  final data = json.decode(response.body);
  
  if (response.statusCode == 200) {
    // التعديل هنا: السيرفر يرسل 'user_token' وليس 'token'
    // ويجب أن نستخدم نفس المفتاح عند الحفظ في SharedPreferences
    if (data.containsKey('user_token')) { 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', data['user_token']); // تأكدي أننا نأخذ القيمة من 'user_token'
      print("تم حفظ التوكين بنجاح: ${data['user_token']}");
    } else {
      print("خطأ: السيرفر لم يرسل مفتاح 'user_token'. الرد كان: $data");
    }
    return UserModel.fromJson(data);
  } else {
    throw Exception(data['message'] ?? 'Failed to login');
  }
}
 
  Future<Map<String, dynamic>> register({
  required String name,
  required String email,
  required String password,
  required String passwordConfirmation,
  required String motherName,
  required String mobile,
  required String birthDate,
  required String sex,
  required String blood,
  required String city,
  required String nationality,
  required String address,
}) async {
  final response = await http.post(
    Uri.parse('${baseUrl}register'),
    body: {
      'name': name,
      'email': email,
      'password': password,
      'c_password': passwordConfirmation,
      'mother_name': motherName,
      'mobile': mobile,
      'birth_date': birthDate,
      'sex': sex,
      'blood': blood,
      'p_city': city,
      'nationality': nationality,
      'address': address,
    },
  );

  print("Register Status: ${response.statusCode}");
  print("Register Body: ${response.body}");

  final data = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // التحقق من وجود التوكين في الاستجابة وحفظه
    // نستخدم data['user_token'] بناءً على ما يرجعه الكنترولر لديك
    if (data.containsKey('user_token')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', data['user_token']);
      print("تم حفظ التوكين بنجاح: ${data['user_token']}");
    }
    
    return data;
  } else {
    // معالجة الأخطاء إذا كانت تأتي داخل مصفوفة errors
    String errorMessage = data['message'] ?? 'Failed to register';
    if (data.containsKey('errors')) {
      errorMessage = data['errors'].toString();
    }
    throw Exception(errorMessage);
  }
}
Future<List<String>> getNationalities() async {
  try {
    print("جاري الاتصال بـ: ${baseUrl}get-nationalities");
    
    final response = await http.get(Uri.parse('${baseUrl}get-nationalities'));
    
    // طباعة كل شيء بوضوح
    print("الحالة: ${response.statusCode}");
    print("الرد: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> list = responseData['data']['nationalities'];
      return list.map((item) => item['name_en'].toString()).toList();
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    print("خطأ كشف الاتصال: $e"); // هنا سنعرف هل المشكلة SocketException أم غيره
    throw e;
  }
}
Future<List<String>> getCities() async {
  // تأكدي أن الرابط هنا هو 'cities' وليس 'get-nationalities'
  final response = await http.get(Uri.parse('${baseUrl}cities')); 
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    // تأكدي من طباعة responseData لترين ما الذي يصل فعلاً
    print("الرد من السيرفر للمدن: $responseData");
    
    List<dynamic> list = responseData['data']['cities'];
    return list.map((item) => item['name'].toString()).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}

Future<void> verifyCode(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  print("إرسال الكود: $code مع التوكين: $token");

  final response = await http.post(
    Uri.parse('${baseUrl}email/verify'), // التعديل هنا: إضافة email/
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
    body: {'code': code},
  );

  print("نتيجة التحقق: ${response.statusCode} - ${response.body}");

  if (response.statusCode != 200) {
    throw Exception('الكود غير صحيح أو انتهت صلاحيته');
  }
}

// دالة إعادة إرسال الكود
Future<void> resendCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  final response = await http.post(
    Uri.parse('${baseUrl}email/resend'), // التعديل هنا: إضافة email/
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );  
  
  if (response.statusCode != 200) {
    throw Exception('فشل في إعادة إرسال الكود');
  }
}

Future<List<dynamic>> getPatientAppointments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token'); 

  final response = await http.get(
    Uri.parse('${baseUrl}patient-appointments'), 
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print("رد السيرفر على المواعيد: ${response.statusCode} - ${response.body}");

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    // التعديل هنا: استخدام المفتاح الصحيح الذي يرسله السيرفر
    // لاحظ أننا نستخدم upcoming_Appointment كما ظهر في الـ Log
    return responseData['upcoming_Appointment'] ?? []; 
  } else {
    throw Exception('فشل جلب المواعيد: ${response.statusCode}');
  }
}
Future<Map<String, dynamic>> getPatientVisits() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token'); 

  final response = await http.get(
    Uri.parse('${baseUrl}visits'), // الرابط الذي أضفناه في api.php
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body); // ترجع الـ Map كاملة (بما فيها مفتاح 'visits')
  } else {
    throw Exception('فشل الاتصال');
  }
}

Future<List<Doctor>> getDoctors(int subgrp) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token'); 

  final response = await http.post(
    Uri.parse('${baseUrl}doctors_by_department'), 
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
    body: {'subgrp': subgrp.toString()},
  );

  print("الرد النهائي من السيرفر: ${response.body}");

  if (response.statusCode == 200) {
    // 1. نقوم بفك ترميز الـ JSON
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    // 2. نستخرج القائمة (التي تحمل اسم 'doctors')
    final List<dynamic> doctorsData = responseData['doctors'];

    // 3. نحول كل عنصر في القائمة إلى كائن من نوع Doctor
    return doctorsData.map((json) => Doctor.fromJson(json)).toList();
    
  } else {
    throw Exception('فشل الاتصال: ${response.statusCode}');
  }
}
}