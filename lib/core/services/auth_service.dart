import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/auth/login/data/models/user_model.dart';
import 'package:wecare/model/doctor_model.dart';
import 'package:wecare/model/visit_model.dart';

class AuthService {
  // تم التعديل إلى http بدلاً من https لتجنب مشاكل شهادات الأمان مع الـ IP
  final String baseUrl = "http://10.231.78.218/api/";

  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}Api_login'),
      body: {'email': email, 'password': password},
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data.containsKey('user_token')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', data['user_token']);
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
      if (data.containsKey('user_token')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', data['user_token']);
        print("تم حفظ التوكين بنجاح: ${data['user_token']}");
      }
      return data;
    } else {
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
      print("خطأ كشف الاتصال: $e");
      rethrow; // استخدام rethrow أفضل برمجياً للحفاظ على مسار الخطأ
    }
  }

  Future<List<String>> getCities() async {
    final response = await http.get(Uri.parse('${baseUrl}cities'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
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
      Uri.parse('${baseUrl}email/verify'),
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

  Future<void> resendCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    final response = await http.post(
      Uri.parse('${baseUrl}email/resend'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في إعادة إرسال الكود');
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> doctorsData = responseData['doctors'];
      return doctorsData.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('فشل الاتصال: ${response.statusCode}');
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

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("DEBUG JSON: ${data['upcoming_Appointment']}");
      return data['upcoming_Appointment'] ?? [];
    } else {
      throw Exception('فشل في جلب المواعيد: ${response.statusCode}');
    }
  }

  // تم دمج الدالة getUpcomingAppointments هنا لأنها كانت تطلب نفس الرابط الخاص بـ getPatientAppointments
  // إذا كانت تؤدي غرضاً مختلفاً في الباك إند، يمكنك تغيير الرابط الخاص بها.

  Future<List<VisitModel>> getUpcomingAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    final response = await http.get(
      Uri.parse('${baseUrl}pat_visits'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> visitsData = data['visits'];
      return visitsData.map((item) => VisitModel.fromJson(item)).toList();
    } else {
      throw Exception('فشل جلب الزيارات');
    }
  }
}